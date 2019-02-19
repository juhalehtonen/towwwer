defmodule PerfMon.Worker do
  alias PerfMon.Tools.PageSpeed
  alias PerfMon.Websites.Report
  alias PerfMon.Websites

  # TODO: Periodically query every Site and send API request for their Monitor(s) path(s)
  # Then create a new Report associated with given Monitor, saving the body of the response
  # as the data in the Report.

  def lol(url) do
    case PageSpeed.query_pagespeed_api(url) do
      {:ok, body} ->
        data = Jason.decode!(body)
        Websites.create_report(%{data: data})
      {:error, reason} ->
        {:error, reason}
    end
  end

end
