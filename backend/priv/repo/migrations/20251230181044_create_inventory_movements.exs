defmodule Backend.Repo.Migrations.CreateInventoryMovements do
  use Ecto.Migration

  def change do
    create table(:inventory_movements, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :quantity, :integer, null: false
      add :movement_type, :string, null: false

      add :item_id,
          references(:items, type: :binary_id, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end

    create index(:inventory_movements, [:item_id])
  end
end
