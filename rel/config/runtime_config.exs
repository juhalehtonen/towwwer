# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.

# ONLY include PRODUCTION RELEASE configuration here, and
# REMEMBER to change everything to their correct values.

# RENAME me to runtime_config.exs to use me

# General application configuration
use Mix.Config

# Endpoint configuration
config :towwwer, TowwwerWeb.Endpoint,
  secret_key_base: "REPLACEMEabcdet45u8tuu549ty5rdy77tghtfghhg7dt9g78th7t89hf78hgt89fgh7f89gh89dfhg7gfg",
  http: [:inet6, port: 4000],
  url: [host: "localhost", port: 4000],
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
config :towwwer, pagespeed_insights_api_key: "REPLACEME"
