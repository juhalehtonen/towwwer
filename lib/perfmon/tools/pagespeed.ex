defmodule PerfMon.Tools.PageSpeed do
  require Logger
  @api_base_url "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url="
  @api_categories "&category=performance&category=pwa&category=best-practices&category=accessibility&category=seo"

  def query_pagespeed_api(url) when is_binary(url) do
    request_url = @api_base_url <> url <> @api_categories
    headers = []
    options = [timeout: 30000, recv_timeout: 30000]

    case HTTPoison.get(request_url, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(reason)
        {:error, reason}
    end
  end
  def query_pagespeed_api(_url), do: {:error, "URL not a binary"}
end
