export type Item = {
  id: string;
  name: string;
  sku: string;
  unit: string;
  stock: number;
};

export type Movement = {
  id: string;
  quantity: number;
  movement_type: "IN" | "OUT" | "ADJUSTMENT";
  inserted_at: string;
};
