defmodule Towwwer.Tools.PageSpeed do
  require Logger

  @api_base_url "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url="
  @api_categories "&category=performance&category=pwa&category=best-practices&category=accessibility&category=seo"

  @spec construct_request_url(String.t(), String.t()) :: String.t()
  def construct_request_url(url, strategy \\ "desktop") when strategy in ["desktop", "mobile"] do
    @api_base_url <> url <> @api_categories <> "&strategy=" <> strategy <> api_key()
  end

  @spec query_pagespeed_api(String.t(), String.t()) ::
          {:ok, map()} | {:ok_but_error, integer()} | {:error, String.t()}
  def query_pagespeed_api(url, strategy)
      when is_binary(url) and strategy in ["desktop", "mobile"] do
    request_url = construct_request_url(url, strategy)
    headers = []
    options = [timeout: 90000, recv_timeout: 90000]

    case HTTPoison.get(request_url, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        Logger.info(
          "HTTPoison request succeeded for #{request_url} but got status code: #{status_code}"
        )

        {:ok_but_error, status_code}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("HTTPoison request failed for #{request_url}: #{reason}")
        {:error, reason}
    end
  end

  def query_pagespeed_api(_url), do: {:error, "URL not a binary"}

  defp api_key do
    key =
      Application.get_env(:towwwer, :pagespeed_insights_api_key) ||
        System.get_env("PAGESPEED_INSIGHTS_API_KEY")

    if key != nil do
      "&key=" <> key
    else
      ""
    end
  end
end
