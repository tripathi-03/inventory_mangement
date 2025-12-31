import { useState } from "react";
import { api } from "../api/client";

export default function MovementForm() {
  const [itemId, setItemId] = useState("");
  const [quantity, setQuantity] = useState(0);
  const [type, setType] = useState("IN");

  const submit = async () => {
    try {
      await api.post("/movements", {
        item_id: itemId,
        quantity,
        movement_type: type,
      });
      alert("Movement recorded");
    } catch (e: any) {
      alert(e.response.data.error);
    }
  };

  return (
    <div>
      <h2>Inventory Movement</h2>
      <input
        placeholder="Item ID"
        onChange={(e) => setItemId(e.target.value)}
      />
      <input
        type="number"
        placeholder="Quantity"
        onChange={(e) => setQuantity(Number(e.target.value))}
      />
      <select onChange={(e) => setType(e.target.value)}>
        <option value="IN">IN</option>
        <option value="OUT">OUT</option>
        <option value="ADJUSTMENT">ADJUSTMENT</option>
      </select>
      <button onClick={submit}>Submit</button>
    </div>
  );
}
