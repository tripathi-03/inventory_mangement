defmodule Backend.Release do
  @app :backend

  def migrate do
    load_app()
    
    # Ensure SSL is configured for database connections
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
    # In releases, always ensure SSL is set for the Repo
    # This is critical for Render's managed PostgreSQL which requires SSL
    repo_config = Application.get_env(@app, Backend.Repo, [])
    
    # Explicitly set SSL to true (runtime.exs should have this, but ensure it's set)
    Application.put_env(@app, Backend.Repo, Keyword.put(repo_config, :ssl, true))
  end
end
