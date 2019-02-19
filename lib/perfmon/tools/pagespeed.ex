defmodule PerfMon.Tools.PageSpeed do
  require Logger
  alias PerfMon.Websites

  @api_base_url "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url="
  @api_categories "&category=performance&category=pwa&category=best-practices&category=accessibility&category=seo"

  def construct_request_url(url), do: @api_base_url <> url <> @api_categories

  def query_pagespeed_api(url) when is_binary(url) do
    request_url = construct_request_url(url)
    headers = []
    options = [timeout: 30000, recv_timeout: 30000]

    case HTTPoison.get(request_url, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error({request_url, reason})
        {:error, reason}
    end
  end
  def query_pagespeed_api(_url), do: {:error, "URL not a binary"}

  def build_report(url, monitor) do
    case query_pagespeed_api(url) do
      {:ok, body} ->
        data = Jason.decode!(body)
        Websites.create_report(%{data: data, monitor: monitor})
      {:error, reason} ->
        {:error, reason}
    end
  end
end
