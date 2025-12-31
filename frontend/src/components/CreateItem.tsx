import { useState } from "react";
import { api } from "../api/client";
import "./CreateItem.css";
export default function CreateItem() {
  const [name, setName] = useState("");
  const [sku, setSku] = useState("");
  const [unit, setUnit] = useState("");
  const [error, setError] = useState<string | null>(null);

  const submit = async () => {
    try {
      setError(null);

      await api.post("/items", {
        name,
        sku,
        unit,
      });

      alert("Item created successfully");

      setName("");
      setSku("");
      setUnit("");
    } catch (err: any) {
      if (err.response?.status === 422) {
        const errors = err.response.data.errors as Record<string, string[]>;
        const firstError = Object.values(errors)[0]?.[0] ?? "Validation error";
        setError(firstError);
      } else {
        setError("Something went wrong");
      }
    }
  };

  return (
    <div>
      <h2>Create Item</h2>

      {error && <p style={{ color: "red" }}>{error}</p>}

      <input
        placeholder="Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />

      <input
        placeholder="SKU"
        value={sku}
        onChange={(e) => setSku(e.target.value)}
      />

      <select value={unit} onChange={(e) => setUnit(e.target.value)}>
        <option value="">Select unit</option>
        <option value="pcs">pcs</option>
        <option value="kg">kg</option>
        <option value="litre">litre</option>
      </select>

      <br />
      <br />

      <button onClick={submit}>Create</button>
    </div>
  );
}
