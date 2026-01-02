defmodule BackendWeb.ItemController do
  use BackendWeb, :controller

  alias Backend.Repo
  alias Backend.Inventory.Item
  alias Backend.Inventory

  # POST /api/items
  def create(conn, params) do
    %Item{}
    |> Item.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, item} ->
        json(conn, %{
          id: item.id,
          name: item.name,
          sku: item.sku,
          unit: item.unit,
          stock: Inventory.get_stock(item.id)
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          errors: translate_errors(changeset)
        })
    end
  end

  # GET /api/items
  def index(conn, _params) do
    try do
      items =
        Item
        |> Repo.all()
        |> Enum.map(fn item ->
          stock = 
            try do
              Inventory.get_stock(item.id)
            rescue
              e ->
                require Logger
                Logger.warn("Error calculating stock for item #{item.id}: #{inspect(e)}")
                0
            end

          %{
            id: item.id,
            name: item.name,
            sku: item.sku,
            unit: item.unit,
            stock: stock
          }
        end)

      json(conn, items)
    rescue
      e in [Postgrex.Error] ->
        # Check if it's an undefined table error
        error_msg = Exception.message(e)
        if error_msg =~ "does not exist" or error_msg =~ "undefined_table" do
          require Logger
          Logger.error("Table does not exist. Run migrations: #{inspect(e)}")
          conn
          |> put_status(:internal_server_error)
          |> json(%{
            error: "Database table missing",
            message: "Please run database migrations: mix ecto.migrate"
          })
        else
          require Logger
          Logger.error("PostgreSQL error: #{inspect(e)}")
          conn
          |> put_status(:service_unavailable)
          |> json(%{
            error: "Database connection error",
            message: "Cannot connect to database. Check DATABASE_URL and connection settings."
          })
        end
      
      e in [Ecto.QueryError] ->
        require Logger
        Logger.error("Query error: #{inspect(e)}")
        conn
        |> put_status(:internal_server_error)
        |> json(%{
          error: "Database query error",
          message: "Please check database migrations and schema"
        })
      
      e ->
        require Logger
        Logger.error("Error in ItemController.index: #{inspect(e)}")
        Logger.error(Exception.format_stacktrace(__STACKTRACE__))
        
        conn
        |> put_status(:internal_server_error)
        |> json(%{
          error: "Internal server error",
          message: "An unexpected error occurred",
          type: inspect(e.__struct__)
        })
    catch
      :exit, {:noproc, _} ->
        require Logger
        Logger.error("Repo process not available - database not started")
        conn
        |> put_status(:service_unavailable)
        |> json(%{
          error: "Database unavailable",
          message: "Database process not running. Check application startup."
        })
      
      :exit, reason ->
        require Logger
        Logger.error("Exit error: #{inspect(reason)}")
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Process exit", message: inspect(reason)})
    end
  end

  # helper
  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
