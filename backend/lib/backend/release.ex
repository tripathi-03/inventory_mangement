defmodule Backend.Release do
  @app :backend

  def migrate do
    load_app()

    for repo <- repos() do
      Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
    end
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  defp migrations_path(repo) do
    priv_dir = :code.priv_dir(@app)
    Path.join([priv_dir, "repo", "migrations"])
  end
end
