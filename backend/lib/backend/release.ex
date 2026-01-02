defmodule Backend.Release do
  @app :backend

  def migrate do
    # Ensure SSL is configured BEFORE loading the app
    ensure_ssl_config()
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    ensure_ssl_config()
    load_app()
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
    
    # For Render's PostgreSQL, we need to ensure SSL opts are properly configured
    # The ssl_opts must be set to handle self-signed certificates
    final_config = [
      url: database_url,
      pool_size: pool_size,
      ssl: true,
      # Critical: verify_none allows self-signed certificates from Render
      ssl_opts: [verify: :verify_none]
    ]
    
    # Delete any existing config and set fresh to avoid conflicts
    Application.delete_env(@app, Backend.Repo)
    Application.put_env(@app, Backend.Repo, final_config, persistent: true)
  end
end
