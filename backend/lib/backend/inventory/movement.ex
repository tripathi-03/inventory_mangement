defmodule Backend.Inventory.Movement do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "inventory_movements" do
    field :quantity, :integer
    field :movement_type, :string

    belongs_to :item, Backend.Inventory.Item

    timestamps(type: :utc_datetime)
  end

  def changeset(movement, attrs) do
    movement
    |> cast(attrs, [:item_id, :quantity, :movement_type])
    |> validate_required([:item_id, :quantity, :movement_type])
    |> validate_number(:quantity, greater_than: 0)
    |> validate_inclusion(:movement_type, ["IN", "OUT", "ADJUSTMENT"])
  end
end
