use Mix.Config

if Mix.env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      DATABASE_URL is missing.
      """

  # Force sslmode=require (Render compatibility)
  database_url =
    if String.contains?(database_url, "sslmode") do
      database_url
    else
      database_url <> "?sslmode=require"
    end

  pool_size =
    case System.get_env("POOL_SIZE") do
      nil -> 10
      value -> String.to_integer(value)
    end

  config :backend, Backend.Repo,
    url: database_url,
    pool_size: pool_size,
    ssl: true,
    ssl_opts: [
      verify: :verify_none
    ]

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      SECRET_KEY_BASE is missing.
      """

  port = String.to_integer(System.get_env("PORT") || "4000")
  host = System.get_env("PHX_HOST") || "example.com"

  config :backend, BackendWeb.Endpoint,
    server: true,
    url: [host: host, scheme: "https", port: 443],
    http: [ip: {0, 0, 0, 0}, port: port],
    secret_key_base: secret_key_base
end
