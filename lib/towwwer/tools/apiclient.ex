defmodule Towwwer.Tools.ApiClient do
  @moduledoc """
  Functions for managing API requests with ExternalService library.
  """
  require Logger
  alias Towwwer.Tools.PageSpeed

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
    # TIMEOUT
    408,
    # RESOURCE_EXHAUSTED
    429,
    # CANCELLED
    499,
    # INTERNAL
    500,
    # UNAVAILABLE
    503,
    # DEADLINE_EXCEEDED
    504
  ]
  @retry_opts %ExternalService.RetryOptions{
    # Exponential backoff, 10000ms between retries
    backoff: {:exponential, 10_000},
    # Stop retrying after 60 seconds.
    expiry: 60_000
  }

  def start do
    ExternalService.start(@fuse_name, @fuse_options)
  end

  def get(url, strategy) when strategy in ["desktop", "mobile"] do
    ExternalService.call(Towwwer.Tools.ApiClient, @retry_opts, fn -> try_get(url, strategy) end)
  end

  @spec try_get(String.t(), String.t()) :: {:retry, integer()} | any()
  defp try_get(url, strategy) when strategy in ["desktop", "mobile"] do
    url
    |> PageSpeed.query_pagespeed_api(strategy)
    |> case do
      {:ok_but_error, status_code} when status_code in @retry_errors ->
        Logger.info("Retrying #{url} due to #{status_code} with strategy of #{strategy}")
        {:retry, status_code}

      # If not a retriable error, just return the result.
      pagespeed_result ->
        pagespeed_result
    end
  end
end
