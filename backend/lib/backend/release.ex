defmodule Backend.Release do
  @app :backend

  def migrate do
    load_app()
    
    # Ensure SSL is configured for database connections before migrations
    ensure_ssl_config()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    ensure_ssl_config()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  defp ensure_ssl_config do
    # For Render's managed PostgreSQL, SSL is REQUIRED
    # We must explicitly set this before Ecto tries to connect
    # When using eval in releases, runtime.exs config might not be fully applied
    repo_config = Application.get_env(@app, Backend.Repo, [])
    
    # Get DATABASE_URL from environment (Render provides this)
    database_url = System.get_env("DATABASE_URL") || Keyword.get(repo_config, :url)
    
    pool_size = case System.get_env("POOL_SIZE") do
      nil -> Keyword.get(repo_config, :pool_size, 10)
      size -> String.to_integer(size)
    end
    
    # Build config with SSL ALWAYS set to true for Render
    # This is critical - Render's PostgreSQL requires SSL connections
    # We merge repo_config first, then override with our SSL settings
    final_config = 
      repo_config
      |> Keyword.put(:ssl, true)  # Force SSL to true
      |> Keyword.put(:url, database_url)  # Ensure DATABASE_URL is set
      |> Keyword.put(:pool_size, pool_size)  # Ensure pool_size is set
    
    # Explicitly set the configuration - this must happen before repo connection
    Application.put_env(@app, Backend.Repo, final_config)
  end
end
