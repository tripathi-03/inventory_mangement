import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      DATABASE_URL environment variable is missing.
      Make sure your PostgreSQL instance is attached to this service
      and use the Internal Database URL if possible.
      """

  pool_size = String.to_integer(System.get_env("POOL_SIZE") || "10")

  config :backend, Backend.Repo,
    url: database_url,
    pool_size: pool_size,
    ssl: true  # This forces SSL/TLS — sufficient for Render Postgres

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "SECRET_KEY_BASE environment variable is missing."

  port = String.to_integer(System.get_env("PORT") || "4000")

  host =
    System.get_env("RENDER_EXTERNAL_HOSTNAME") ||
      System.get_env("HOST") ||
      "example.com"  # Replace with your actual custom domain or onrender.com subdomain

  config :backend, BackendWeb.Endpoint,
    server: true,
    http: [ip: {0, 0, 0, 0}, port: port],
    url: [scheme: "https", host: host, port: 443],
    secret_key_base: secret_key_base
end
