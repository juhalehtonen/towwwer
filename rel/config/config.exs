# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.

# ONLY include PRODUCTION RELEASE configuration here

# General application configuration
use Mix.Config

# Configure your database
config :towwwer, Towwwer.Repo,
  username: "postgres",
  password: "postgres",
  database: "towwwer_prod",
  pool_size: 15

# Configure PageSpeeds Insights API
config :towwwer, pagespeed_insights_api_key: "123"
