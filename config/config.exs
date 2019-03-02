# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :perfmon,
  namespace: PerfMon,
  ecto_repos: [PerfMon.Repo]

# Configures the endpoint
config :perfmon, PerfMonWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "h/NPnWwIeIciKK9rSRyREk2lii7roCVWsOTgR861gx6TO/m1ScnEMMFTySJ02/cc",
  render_errors: [view: PerfMonWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PerfMon.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure Rihanna
config :rihanna,
  producer_postgres_connection: {Ecto, PerfMon.Repo},
  dispatcher_max_concurrency: 100

# Shared secrets usable for any environment, such as API keys
import_config "shared.secret.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
