# PerfMon

PerfMon is a tool for monitoring, collecting and presenting website performance data collected from Google PageSpeed Insights API.

## Configuration

While the PageSpeed Insights API can be used without an API key, you will want to use one for anything more than a single Site + Monitor combination.

Configure the PageSpeed Insights API key by creating a `config/shared.secret.exs` file and filling it with the following:

```elixir
use Mix.Config

# Configure PageSpeeds Insights API
config :perfmon, pagespeed_insights_api_key: "YOUR_API_KEY_HERE"
```

## Local Phoenix

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## License

PerfMon is licensed under the MIT License.
