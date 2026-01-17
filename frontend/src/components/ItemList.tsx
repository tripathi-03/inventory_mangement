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
    <div className="card">
      <div className="card-header">
        <h2 className="card-title">Items</h2>
        <p className="card-subtitle">Live view of available inventory.</p>
      </div>

      {isLoading && <p className="status">Loading items...</p>}
      {error && <p className="status error">{error}</p>}

      <ul className="list">
        {items.map((item) => (
          <li key={item.id} className="list-item">
            <div>
              <p className="item-name">{item.name}</p>
              <p className="item-meta">{item.sku}</p>
            </div>
            <span className="badge">Stock: {item.stock}</span>
          </li>
        ))}
      </ul>
    </div>
  );
}
