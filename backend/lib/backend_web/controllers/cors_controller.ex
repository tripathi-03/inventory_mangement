defmodule BackendWeb.CORSController do
  use BackendWeb, :controller

  def options(conn, _params) do
    # CORSPlug will add the necessary headers
    # We just need to return a 204 No Content response
    conn
    |> put_status(:no_content)
    |> send_resp(204, "")
  end
end

