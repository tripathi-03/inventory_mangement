import { useCallback, useState } from "react";
import { api } from "../api/client";
export default function CreateItem() {
  const [name, setName] = useState("");
  const [sku, setSku] = useState("");
  const [unit, setUnit] = useState("");
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

      await api.post("/items", {
        name: name.trim(),
        sku: sku.trim(),
        unit,
      });

      setSuccess("Item created successfully");

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
    } finally {
      setIsSubmitting(false);
    }
  }, [isSubmitting, name, sku, unit]);

  return (
    <div className="card">
      <div className="card-header">
        <h2 className="card-title">Create Item</h2>
        <p className="card-subtitle">Add new stock keeping units fast.</p>
      </div>

      {error && <p className="status error">{error}</p>}
      {success && <p className="status success">{success}</p>}

      <div className="form">
        <label className="field">
          <span className="label">Item name</span>
          <input
            className="input"
            placeholder="e.g. Organic rice"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
        </label>

        <label className="field">
          <span className="label">SKU</span>
          <input
            className="input"
            placeholder="e.g. RICE-001"
            value={sku}
            onChange={(e) => setSku(e.target.value)}
          />
        </label>

        <label className="field">
          <span className="label">Unit</span>
          <select
            className="select"
            value={unit}
            onChange={(e) => setUnit(e.target.value)}
          >
            <option value="">Select unit</option>
            <option value="pcs">pcs</option>
            <option value="kg">kg</option>
            <option value="litre">litre</option>
          </select>
        </label>

        <button
          className="btn primary"
          onClick={submit}
          disabled={isSubmitting || !name.trim() || !sku.trim() || !unit}
        >
          {isSubmitting ? "Creating..." : "Create"}
        </button>
      </div>
    </div>
  );
}
