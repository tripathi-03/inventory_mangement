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
    # When using eval in releases, we need to completely rebuild the config
    database_url = System.get_env("DATABASE_URL") || 
      raise "DATABASE_URL environment variable is not set"
    
    pool_size = case System.get_env("POOL_SIZE") do
      nil -> 10
      size -> String.to_integer(size)
    end
    
    # Completely rebuild the config from scratch to ensure SSL is set
    # This is critical - Render's PostgreSQL requires SSL connections
    final_config = [
      url: database_url,
      pool_size: pool_size,
      ssl: true
    ]
    
    # Delete any existing config and set fresh to avoid conflicts
    Application.delete_env(@app, Backend.Repo)
    Application.put_env(@app, Backend.Repo, final_config, persistent: true)
  end
end
