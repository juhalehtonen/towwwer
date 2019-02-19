defmodule PerfMon.Worker do
  alias PerfMon.Tools.PageSpeed
  alias PerfMon.Websites

  # TODO: Periodically query every Site and send API request for their Monitor(s) path(s)
  # Then create a new Report associated with given Monitor, saving the body of the response
  # as the data in the Report.

  def loop_sites_for_reports do
    sites = Websites.list_sites()
    # Loop through all sites and every monitor of every site
    for site <- sites do
      for monitor <- site.monitors do
        {:ok, pid} = Task.Supervisor.start_child(PerfMon.TaskSupervisor, fn ->
          # Avoid hitting API limits :D TODO: Just get an API key
          :timer.sleep(5000)
          build_report(site.base_url <> monitor.path, monitor)
        end)
      end
    end
  end

  def build_report(url, monitor) do
    case PageSpeed.query_pagespeed_api(url) do
      {:ok, body} ->
        data = Jason.decode!(body)
        Websites.create_report(%{data: data, monitor: monitor})
      {:error, reason} ->
        {:error, reason}
    end
  end

end
