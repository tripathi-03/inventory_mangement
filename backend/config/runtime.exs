import Config

# Enable Phoenix server in releases
if System.get_env("PHX_SERVER") do
  config :backend, BackendWeb.Endpoint, server: true
end

config :backend, BackendWeb.Endpoint,
  http: [
    ip: {0, 0, 0, 0},
    port: String.to_integer(System.get_env("PORT", "4000"))
  ]

if config_env() == :prod do
  database_url =
    System.fetch_env!("DATABASE_URL")

  secret_key_base =
    System.fetch_env!("SECRET_KEY_BASE")

  config :backend, Backend.Repo,
    url: database_url,
    ssl: true,
    ssl_opts: [
      verify: :verify_none
    ],
    pool_size: String.to_integer(System.get_env("POOL_SIZE", "10"))

  config :backend, BackendWeb.Endpoint,
    url: [host: System.get_env("PHX_HOST", "localhost"), port: 443],
    secret_key_base: secret_key_base,
    force_ssl: [rewrite_on: [:x_forwarded_proto]]
end
