defmodule BackendWeb.MovementController do
  use BackendWeb, :controller

  import Ecto.Query

  alias Backend.Repo
  alias Backend.Inventory
  alias Backend.Inventory.Movement

  # POST /api/movements
  def create(conn, params) do
    case Inventory.create_movement(params) do
      {:ok, movement} ->
        json(conn, %{
          id: movement.id,
          item_id: movement.item_id,
          quantity: movement.quantity,
          movement_type: movement.movement_type,
          inserted_at: movement.inserted_at
        })

      {:error, reason} when is_binary(reason) ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          errors: translate_errors(changeset)
        })
    end
  end

  # GET /api/items/:id/movements
  def history(conn, %{"id" => item_id}) do
    movements =
      from(m in Movement,
        where: m.item_id == ^item_id,
        order_by: [desc: m.inserted_at]
      )
      |> Repo.all()
      |> Enum.map(fn m ->
        %{
          id: m.id,
          item_id: m.item_id,
          quantity: m.quantity,
          movement_type: m.movement_type,
          inserted_at: m.inserted_at
        }
      end)

    json(conn, movements)
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
