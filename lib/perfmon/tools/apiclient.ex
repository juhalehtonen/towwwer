defmodule PerfMon.Tools.ApiClient do
  require Logger
  alias PerfMon.Tools.PageSpeed

  @fuse_name __MODULE__
  @fuse_options [
    # Tolerate 2 failures for every 5 second time window.
    fuse_strategy: {:standard, 2, 5000},
    # Reset the fuse 60 seconds after it is blown.
    fuse_refresh: 60_000,
    # Limit to 60 calls per 100 seconds
    rate_limit: {1, 1200}
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
    # Exponential backoff, 10000ms between retries
    backoff: {:exponential, 10_000},
    # Stop retrying after 60 seconds.
    expiry: 60_000,
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
         {:ok_but_error, status_code} when status_code in @retry_errors ->
           Logger.info "Retrying #{url} due to #{status_code}"
           IO.inspect {:retry, status_code}
         # If not a retriable error, just return the result.
         pagespeed_result ->
           pagespeed_result
       end
  end
end
