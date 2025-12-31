defmodule Backend.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :sku, :string, null: false
      add :unit, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:items, [:sku])
  end
end
