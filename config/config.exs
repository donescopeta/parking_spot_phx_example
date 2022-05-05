# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

config :web,
  generators: [context_app: :parking]

# Configures the endpoint
config :web, Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GQeolOyDgQzMZIrEKZQrKygxg0qLkYVz0QW5vo/zHqEW6vcRRIcSlaxL56wxHxl8",
  render_errors: [view: Web.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Parking.PubSub,
  live_view: [signing_salt: "HvESvkAi"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

config :parking_crawlers,
  endpoint_url: "http://private-b2c96-mojeprahaapi.apiary-mock.com/pr-parkings/",
  resources: [
    %{id: "534013", refresh_period: 5},
    %{id: "534015", refresh_period: 5}
  ],
  max_requests_per_minute: 1000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
