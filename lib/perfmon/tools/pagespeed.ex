defmodule PerfMon.Tools.PageSpeed do
  @api_base_url "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url="

  def query_pagespeed_api(url) when is_binary(url) do
    case HTTPoison.get(@api_base_url <> url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
  def query_pagespeed_api(_url), do: {:error, "URL not a binary"}
end
