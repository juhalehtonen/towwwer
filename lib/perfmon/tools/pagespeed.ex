defmodule PerfMon.Tools.PageSpeed do
  require Logger
  alias PerfMon.Websites

  @api_key Application.get_env(:perfmon, :pagespeed_insights_api_key)
  @api_base_url "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url="
  @api_categories "&category=performance&category=pwa&category=best-practices&category=accessibility&category=seo"

  def construct_request_url(url),
    do: @api_base_url <> url <> @api_categories <> "&key=" <> @api_key

  def query_pagespeed_api(url) when is_binary(url) do
    request_url = construct_request_url(url)
    headers = []
    options = [timeout: 60000, recv_timeout: 60000]

    case HTTPoison.get(request_url, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, status_code}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("HTTPoison request failed")
        {:error, reason}
    end
  end

  def query_pagespeed_api(_url), do: {:error, "URL not a binary"}

  @doc """
  Constructs and saves a new Report from the JSON response of the
  PageSpeed API.
  """
  def build_report(url, monitor) do
    case PerfMon.Tools.ApiClient.get(url) do
      {:ok, body} ->
        data = Jason.decode!(body)
        Websites.create_report(%{data: data, monitor: monitor})

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Runs a build task for each monitor under given `site`.
  """
  def run_build_task_for_site_monitors(site) when is_map(site) do
    for monitor <- site.monitors do
      build_task(site, monitor)
    end
  end

  @doc """
  Run a build task for every newly added site monitor, but not the existing
  ones.
  """
  def run_build_task_for_new_site_monitors(site) when is_map(site) do
    for monitor <- site.monitors do
      if monitor.updated_at == monitor.inserted_at do
        build_task(site, monitor)
      end
    end
  end

  defp build_task(site, monitor) do
    # Cheap way of "load balancing" our requests to avoid hitting the API rate limit.
    # 5 seconds is just enough to do 20req/100s or 0,2req/1s in the allowed time limit.
    # :timer.sleep(5000)

    Task.Supervisor.start_child(PerfMon.TaskSupervisor, fn ->
      build_report(site.base_url <> monitor.path, monitor)
      Websites.bump_site_timestamp(site)
    end)
  end
end
