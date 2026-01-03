defmodule BackendWeb.CORSController do
  use BackendWeb, :controller

  def options(conn, _params) do
    # CORS headers are handled by the endpoint's handle_preflight plug
    # This controller is kept for compatibility but may not be needed
    conn
    |> put_status(:no_content)
    |> send_resp(204, "")
  end
end

