# Towwwer

[![CircleCI](https://circleci.com/gh/juhalehtonen/towwwer.svg?style=svg)](https://circleci.com/gh/juhalehtonen/towwwer)

Towwwer is a tool for monitoring, collecting and presenting website performance data collected from Google PageSpeed Insights API.

Additionally, Towwwer can run [WPScan](https://github.com/wpscanteam/wpscan) against the monitored websites and keep track of which security issues are found. WPScan is a separate project, and their license details differ from those of Towwwer.

## Requirements

To run Towwwer, you need:

  * Elixir (or a release built for your system with ERTS bundled in)
  * PostgreSQL (for storing the reports & job queue)
  * Ruby and RubyGems (for installing WPScan)
  
## Configuration

While the PageSpeed Insights API can be used without an API key, you will want to use one for anything more than a single Site + Monitor combination.

### Development configuration

Configure the PageSpeed Insights API key by setting the `PAGESPEED_INSIGHTS_API_KEY` environment variable.

### Production configuration

Configure the PageSpeed Insights API key by using the config provider of Distillery at `rel/config/runtime_config.exs`.

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

Test local "deployment": `cp rel/artifacts/towwwer-0.1.0.tar.gz /tmp/test/`

Start the release with: `cd /tmp/test && tar -xf towwwer-0.1.0.tar.gz && ./bin/towwwer start`

## Production migrations

You can run migrations in production with `bin/towwwer migrate`. This is handled by `rel/commands/migrate.sh` and `Towwwer.ReleaseTasks`.

## Features

### Currently implemented

  * Unlimited sites (think domain), monitors (paths for a site), and reports (data for a monitor)
  * Automatic daily (or configurable) updates for every site & monitor reports
  * PostgreSQL-backed job queue
  * WPScan security scans alongside PageSpeed Insights
  * Rate limiting to respect Google API quotas
  * Friendly API for fetching the most relevant information
  
### Planned

  * Slack integration

## Testing

The following should always pass:

```
mix test
mix dialyzer
```

## Local Phoenix

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## License

Towwwer is licensed under the [MIT License](LICENSE).
