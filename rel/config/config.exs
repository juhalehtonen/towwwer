# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.

# ONLY include PRODUCTION RELEASE configuration here, and
# REMEMBER to change everything to their correct values.

# General application configuration
use Mix.Config

# Endpoint configuration
config :towwwer, TowwwerWeb.Endpoint,
  secret_key_base: "abcdefg",
  http: [:inet6, port: 4000],
  url: [host: "example.com", port: 4000],
  server: true,
  root: ".",
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :towwwer, Towwwer.Repo,
  username: "postgres",
  password: "postgres",
  database: "towwwer_prod",
  pool_size: 15

# Configure PageSpeeds Insights API
config :towwwer, pagespeed_insights_api_key: "123"
