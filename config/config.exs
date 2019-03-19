# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :towwwer,
  namespace: Towwwer,
  ecto_repos: [Towwwer.Repo]

# Configures the endpoint
config :towwwer, TowwwerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "h/NPnWwIeIciKK9rSRyREk2lii7roCVWsOTgR861gx6TO/m1ScnEMMFTySJ02/cc",
  render_errors: [view: TowwwerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Towwwer.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure Rihanna
config :rihanna,
  producer_postgres_connection: {Ecto, Towwwer.Repo},
  dispatcher_max_concurrency: 10


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
