defmodule BackendWeb.HealthController do
  use BackendWeb, :controller

  alias Backend.Repo

  def check(conn, _params) do
    db_status = check_database()
    
    status = if db_status[:connected], do: :ok, else: :service_unavailable
    
    conn
    |> put_status(status)
    |> json(%{
      status: if(db_status[:connected], do: "ok", else: "error"),
      database: db_status
    })
  end

  defp check_database do
    try do
      # Try a simple query to check connection
      case Repo.query("SELECT 1", []) do
        {:ok, _} ->
          # Check if tables exist
          tables_exist = check_tables()
          %{
            connected: true,
            tables_exist: tables_exist,
            message: if(tables_exist, do: "Database connected and tables exist", else: "Database connected but tables missing - run migrations")
          }
        error ->
          %{
            connected: false,
            error: inspect(error),
            message: "Database query failed"
          }
      end
    rescue
      e in [Postgrex.Error] ->
        %{
          connected: false,
          error: inspect(e),
          message: "Cannot connect to database. Check DATABASE_URL environment variable."
        }
      e ->
        %{
          connected: false,
          error: inspect(e),
          message: "Database check failed: #{inspect(e)}"
        }
    catch
      :exit, {:noproc, _} ->
        %{
          connected: false,
          message: "Database process not running"
        }
      :exit, reason ->
        %{
          connected: false,
          error: inspect(reason),
          message: "Database process exited"
        }
    end
  end

  defp check_tables do
    try do
      # Check if items table exists
      case Repo.query("SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'items')", []) do
        {:ok, %{rows: [[true]]}} ->
          # Check if movements table exists
          case Repo.query("SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'inventory_movements')", []) do
            {:ok, %{rows: [[true]]}} -> true
            _ -> false
          end
        _ -> false
      end
    rescue
      _ -> false
    end
  end
end

