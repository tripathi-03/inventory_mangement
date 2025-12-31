use Mix.Config

if Mix.env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise "DATABASE_URL missing"

  pool_size =
    String.to_integer(System.get_env("POOL_SIZE") || "10")

  ssl_ca_cert =
    System.get_env("DATABASE_CA_CERT") ||
      System.get_env("RENDER_DATABASE_CA_CERT") ||
      raise """
      Render CA certificate not found.
      Is the PostgreSQL database ATTACHED to this service?
      """

  config :backend, Backend.Repo,
    url: database_url,
    pool_size: pool_size,
    ssl: true,
    ssl_opts: [
      cacertfile: ssl_ca_cert
    ]

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "SECRET_KEY_BASE missing"

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :backend, BackendWeb.Endpoint,
    server: true,
    http: [ip: {0, 0, 0, 0}, port: port],
    url: [scheme: "https", host: "example.com", port: 443],
    secret_key_base: secret_key_base
end
