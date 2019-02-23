defmodule PerfMon.Tools.ApiClient do
  alias PerfMon.Tools.PageSpeed

  @fuse_name __MODULE__
  @fuse_options [
    # Tolerate 30 failures for every 1 second time window.
    fuse_strategy: {:standard, 30, 1000},
    # Reset the fuse 5 seconds after it is blown.
    fuse_refresh: 5000,
    # Limit to 60 calls per 100 seconds
    rate_limit: {60, 100_000}
  ]
  @retry_errors [
    408, # TIMEOUT
    429, # RESOURCE_EXHAUSTED
    499, # CANCELLED
    500, # INTERNAL
    503, # UNAVAILABLE
    504, # DEADLINE_EXCEEDED
  ]
  @retry_opts %ExternalService.RetryOptions{
    # Exponential backoff, 1000ms between retries
    backoff: {:exponential, 1000},
    # Stop retrying after 240 seconds.
    expiry: 240_000,
  }

  def start do
    ExternalService.start(@fuse_name, @fuse_options)
  end

  def get(url) do
    ExternalService.call(PerfMon.Tools.ApiClient, @retry_opts, fn -> try_get(url) end)
  end

  defp try_get(url) do
    url
    |> PageSpeed.query_pagespeed_api()
    |> case do
         {:error, status_code} when status_code in @retry_errors ->
           IO.inspect url
           IO.inspect {:retry, status_code}
         # If not a retriable error, just return the result.
         pagespeed_result ->
           pagespeed_result
       end
  end
end
