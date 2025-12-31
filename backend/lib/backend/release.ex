import Config

# Force SSL in production (Render terminates HTTPS)
config :backend, BackendWeb.Endpoint,
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  exclude: [
    hosts: ["localhost", "127.0.0.1"]
  ],
  server: true

# Always enable SSL for database connections in production
config :backend, Backend.Repo,
  ssl: true

# Swoosh configuration for production
config :swoosh, api_client: Swoosh.ApiClient.Req
config :swoosh, local: false

# Reduce logging noise in production
config :logger, level: :info
