import { useEffect, useState } from "react";
import { api } from "../api/client";
import type { Item } from "../types/types";

export default function ItemList() {
  const [items, setItems] = useState<Item[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const controller = new AbortController();

    setIsLoading(true);
    setError(null);

    api
      .get("/items", { signal: controller.signal })
      .then((res) => setItems(res.data))
      .catch((err) => {
        if (err.name !== "CanceledError") {
          setError("Failed to load items");
        }
      })
      .finally(() => setIsLoading(false));

    return () => controller.abort();
  }, []);

  return (
    <div>
      <h2>Items</h2>
      {isLoading && <p>Loading items...</p>}
      {error && <p style={{ color: "red" }}>{error}</p>}
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
