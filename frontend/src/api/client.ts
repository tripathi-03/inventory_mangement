import axios from "axios";

export const api = axios.create({
  baseURL: "https://inventory-mangement-0dro.onrender.com//api",
});
