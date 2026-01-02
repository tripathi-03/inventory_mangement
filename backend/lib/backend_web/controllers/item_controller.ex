defmodule BackendWeb.ItemController do
  use BackendWeb, :controller

  alias Backend.Repo
  alias Backend.Inventory.Item
  alias Backend.Inventory

  # POST /api/items
  def create(conn, params) do
    %Item{}
    |> Item.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, item} ->
        json(conn, %{
          id: item.id,
          name: item.name,
          sku: item.sku,
          unit: item.unit,
          stock: Inventory.get_stock(item.id)
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          errors: translate_errors(changeset)
        })
    end
  end

  # GET /api/items
  def index(conn, _params) do
    items =
      Item
      |> Repo.all()
      |> Enum.map(fn item ->
        %{
          id: item.id,
          name: item.name,
          sku: item.sku,
          unit: item.unit,
          stock: Inventory.get_stock(item.id)
        }
      end)

    json(conn, items)
  end

  # helper
  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
