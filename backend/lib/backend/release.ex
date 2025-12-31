defmodule Backend.Release do
  @app :backend

  def migrate do
    Application.ensure_all_started(@app)

    for repo <- Application.fetch_env!(@app, :ecto_repos) do
      Ecto.Migrator.run(repo, migrations_path(), :up, all: true)
    end
  end

  defp migrations_path do
    priv_dir = :code.priv_dir(@app)
    Path.join(priv_dir, "repo/migrations")
  end
end
