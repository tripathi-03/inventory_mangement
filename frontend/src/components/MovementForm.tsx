import { useCallback, useState } from "react";
import { api } from "../api/client";

export default function MovementForm() {
  const [itemId, setItemId] = useState("");
  const [quantity, setQuantity] = useState(0);
  const [type, setType] = useState("IN");
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const submit = useCallback(async () => {
    if (isSubmitting) {
      return;
    }

    try {
      setIsSubmitting(true);
      setError(null);
      setSuccess(null);

      await api.post("/movements", {
        item_id: itemId,
        quantity,
        movement_type: type,
      });
      setSuccess("Movement recorded");
    } catch (e: any) {
      setError(e.response?.data?.error ?? "Failed to record movement");
    } finally {
      setIsSubmitting(false);
    }
  }, [isSubmitting, itemId, quantity, type]);

  return (
    <div>
      <h2>Inventory Movement</h2>
      {error && <p style={{ color: "red" }}>{error}</p>}
      {success && <p style={{ color: "green" }}>{success}</p>}
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
      <button onClick={submit} disabled={isSubmitting}>
        {isSubmitting ? "Submitting..." : "Submit"}
      </button>
    </div>
  );
}
