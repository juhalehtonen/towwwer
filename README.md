# Towwwer

Towwwer is a tool for monitoring, collecting and presenting website performance data collected from Google PageSpeed Insights API.

Additionally, Towwwer can run [WPScan](https://github.com/wpscanteam/wpscan) against the monitored websites and keep track of which security issues are found. WPScan is a separate project, and their license details differ from those of Towwwer.

## Requirements

To run Towwwer, you need:

  * Elixir (or a release built for your system with ERTS bundled in)
  * PostgreSQL (for storing the reports & job queue)
  * Ruby and RubyGems (for installing WPScan)

## Configuration

While the PageSpeed Insights API can be used without an API key, you will want to use one for anything more than a single Site + Monitor combination.

Configure the PageSpeed Insights API key by creating a `config/shared.secret.exs` file and filling it with the following:

```elixir
use Mix.Config

# Configure PageSpeeds Insights API
config :towwwer, pagespeed_insights_api_key: "YOUR_API_KEY_HERE"
```

NOTE: You can use different configurations for different environments. The shared config is included for all environments by default.

## Deployment

Towwwer uses Distillery to build releases for production. See the [Distillery docs](https://hexdocs.pm/distillery) for more details.

Steps taken to produce a new deployment:

```
# To build the Docker image
docker build -t elixir-ubuntu:latest .

# To build the release
docker run -v $(pwd):/opt/build --rm -it elixir-ubuntu:latest /opt/build/bin/build
```

After which you should see your release tarball in `rel/artifacts`.

If you add dependencies that require system packages, you will need to update the Dockerfile for the build container, and rerun the docker build command to update it.

## Features

Currently implemented:

  * Unlimited sites (think domain), monitors (paths for a site), and reports (API response data for a monitor)
  * Automatic daily (or configurable) updates for every site & monitor reports
  * PostgreSQL-backed job queue
  * WPScan security scans alongside PageSpeed Insights
  * Rate limiting to respect Google API quotas
  * Visual viewer for comparing historical data
  
Planned:
  * Slack integration
  * Friendly API for fetching the most relevant information

## Local Phoenix

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## License

Towwwer is licensed under the [MIT License](LICENSE).
