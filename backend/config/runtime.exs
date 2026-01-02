import Config

if config_env() == :prod do
  # Database configuration
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      DATABASE_URL is missing.
      Make sure your PostgreSQL instance is attached to this service
      (or manually set DATABASE_URL to the Internal connection string).
      """

  pool_size = String.to_integer(System.get_env("POOL_SIZE") || "10")

  config :backend, Backend.Repo,
    url: database_url,
    pool_size: pool_size,
    ssl: true,
    ssl_opts: [verify: :verify_none]

  # Secret key base (required for sessions, signing, etc.)
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "SECRET_KEY_BASE environment variable is missing."

  # Port binding (Render injects PORT)
  port = String.to_integer(System.get_env("PORT") || "4000")

  # Dynamic host for URLs (uses your .onrender.com domain or custom domain)
  host =
    System.get_env("RENDER_EXTERNAL_HOSTNAME") ||
      System.get_env("HOST") ||
      raise "Host not set. Render usually sets RENDER_EXTERNAL_HOSTNAME automatically."

  config :backend, BackendWeb.Endpoint,
    http: [ip: {0, 0, 0, 0}, port: port],
    url: [scheme: "https", host: host, port: 443],
    secret_key_base: secret_key_base
end
