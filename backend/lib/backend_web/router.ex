defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendWeb do
    pipe_through :api

    post "/items", ItemController, :create
    get "/items", ItemController, :index
    options "/items", ItemController, :options

    post "/movements", MovementController, :create
    options "/movements", MovementController, :options
    get "/items/:id/movements", MovementController, :history
    options "/items/:id/movements", MovementController, :options
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:backend, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BackendWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
