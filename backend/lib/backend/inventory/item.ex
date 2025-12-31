defmodule Backend.Inventory.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "items" do
    field :name, :string
    field :sku, :string
    field :unit, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :sku, :unit])
    |> validate_required([:name, :sku, :unit])
    |> unique_constraint(:sku)
  end
end
