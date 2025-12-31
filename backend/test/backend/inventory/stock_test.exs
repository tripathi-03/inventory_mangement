defmodule Backend.Inventory.StockTest do
  use Backend.DataCase

  alias Backend.Repo
  alias Backend.Inventory
  alias Backend.Inventory.{Item, Movement}

  test "stock calculation works" do
    {:ok, item} =
      %Item{}
      |> Item.changeset(%{
        name: "Pen",
        sku: "P1",
        unit: "pcs"
      })
      |> Repo.insert()

    Repo.insert!(%Movement{
      item_id: item.id,
      quantity: 10,
      movement_type: "IN"
    })

    Repo.insert!(%Movement{
      item_id: item.id,
      quantity: 3,
      movement_type: "OUT"
    })

    assert Inventory.get_stock(item.id) == 7
  end
end
