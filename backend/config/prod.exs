# import Config

# # Force using SSL in production. This also sets the "strict-security-transport" header,
# # known as HSTS. If you have a health check endpoint, you may want to exclude it below.
# # Note `:force_ssl` is required to be set at compile-time.
# config :backend, BackendWeb.Endpoint,
#   force_ssl: [rewrite_on: [:x_forwarded_proto]],
#   exclude: [
#     # paths: ["/health"],
#     hosts: ["localhost", "127.0.0.1"]
#   ]

# # Configure Swoosh API Client
# config :swoosh, api_client: Swoosh.ApiClient.Req

# # Disable Swoosh Local Memory Storage
# config :swoosh, local: false

# # Do not print debug messages in production
# config :logger, level: :info

# # Runtime production configuration, including reading
# # of environment variables, is done on config/runtime.exs.


#---------

import Config

# Force SSL in production (safe behind Render / reverse proxy)
config :backend, BackendWeb.Endpoint,
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  exclude: [
    hosts: ["localhost", "127.0.0.1"]
  ],
  server: true

# Configure Repo (values injected at runtime)
config :backend, Backend.Repo,
  ssl: true,
  ssl_opts: [verify: :verify_none]

# Configure CORS
config :cors_plug,
  origin: [
    "http://localhost:5173",
    ~r/https?:\/\/.*\.onrender\.com/,
    ~r/https?:\/\/.*\.vercel\.app/
  ],
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  headers: ["Authorization", "Content-Type", "Accept"]

# Swoosh (safe defaults for production)
config :swoosh, api_client: Swoosh.ApiClient.Req
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info
