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
    <div className="card">
      <div className="card-header">
        <h2 className="card-title">Inventory Movement</h2>
        <p className="card-subtitle">Record incoming and outgoing stock.</p>
      </div>

      {error && <p className="status error">{error}</p>}
      {success && <p className="status success">{success}</p>}

      <div className="form">
        <label className="field">
          <span className="label">Item ID</span>
          <input
            className="input"
            placeholder="Enter item ID"
            onChange={(e) => setItemId(e.target.value)}
          />
        </label>

        <label className="field">
          <span className="label">Quantity</span>
          <input
            className="input"
            type="number"
            placeholder="0"
            onChange={(e) => setQuantity(Number(e.target.value))}
          />
        </label>

        <label className="field">
          <span className="label">Movement type</span>
          <select className="select" onChange={(e) => setType(e.target.value)}>
            <option value="IN">IN</option>
            <option value="OUT">OUT</option>
            <option value="ADJUSTMENT">ADJUSTMENT</option>
          </select>
        </label>

        <button className="btn primary" onClick={submit} disabled={isSubmitting}>
          {isSubmitting ? "Submitting..." : "Submit"}
        </button>
      </div>
    </div>
  );
}
