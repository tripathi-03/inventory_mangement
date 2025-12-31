defmodule Backend.Inventory do
  import Ecto.Query

  alias Backend.Repo
  alias Backend.Inventory.Movement

  def get_stock(item_id) do
    from(m in Movement,
      where: m.item_id == ^item_id,
      select:
        sum(
          fragment(
            "CASE
               WHEN ? = 'IN' THEN ?
               WHEN ? = 'OUT' THEN -?
               ELSE ?
             END",
            m.movement_type, m.quantity,
            m.movement_type, m.quantity,
            m.quantity
          )
        )
    )
    |> Repo.one()
    || 0
  end

  def create_movement(attrs) do
    item_id = attrs["item_id"]
    movement_type = attrs["movement_type"]
    quantity = attrs["quantity"]

    current_stock = get_stock(item_id)
    delta = stock_delta(movement_type, quantity)
    new_stock = current_stock + delta

    if new_stock < 0 do
      {:error, "Stock cannot be negative"}
    else
      %Movement{}
      |> Movement.changeset(%{
        item_id: item_id,
        movement_type: movement_type,
        quantity: quantity
      })
      |> Repo.insert()
    end
  end

  defp stock_delta("IN", q), do: q
  defp stock_delta("OUT", q), do: -q
  defp stock_delta("ADJUSTMENT", q), do: q
end
