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
    try do
      items =
        Item
        |> Repo.all()
        |> Enum.map(fn item ->
          stock = 
            try do
              Inventory.get_stock(item.id)
            rescue
              _ -> 0
            end

          %{
            id: item.id,
            name: item.name,
            sku: item.sku,
            unit: item.unit,
            stock: stock
          }
        end)

      json(conn, items)
    rescue
      e ->
        # Log the error for debugging
        require Logger
        Logger.error("Error in ItemController.index: #{inspect(e)}")
        Logger.error(Exception.format_stacktrace(__STACKTRACE__))
        
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Internal server error", detail: inspect(e)})
    end
  end

  # helper
  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
