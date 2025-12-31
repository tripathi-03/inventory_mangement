import { useEffect, useState } from "react";
import { api } from "../api/client";
import type { Item } from "../types/types";

export default function ItemList() {
  const [items, setItems] = useState<Item[]>([]);

  useEffect(() => {
    api.get("/items").then((res) => setItems(res.data));
  }, []);

  return (
    <div>
      <h2>Items</h2>
      <ul>
        {items.map((item) => (
          <li key={item.id}>
            {item.name} ({item.sku}) — Stock: {item.stock}
          </li>
        ))}
      </ul>
    </div>
  );
}
