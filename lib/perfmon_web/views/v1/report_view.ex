defmodule PerfMonWeb.V1.ReportView do
  use PerfMonWeb, :view
  alias PerfMonWeb.V1.ReportView

  def render("index.json", %{reports: reports}) do
    %{data: render_many(reports, ReportView, "report.json")}
  end

  def render("show.json", %{report: report}) do
    %{data: render_one(report, ReportView, "report.json")}
  end

  def render("report.json", %{report: report}) do
    %{
      id: report.id,
      monitor_id: report.monitor_id,
      timestamp: report.inserted_at,
      performance: score(report, "performance"),
      seo: score(report, "seo"),
      accessibility: score(report, "accessibility"),
      "best-practices": score(report, "best-practices"),
      pwa: score(report, "pwa"),
      issues: extract_issues(report),
      "interesting-findings": report.wpscan_data["interesting_findings"]
    }
  end

  # Score extracted from saved lighthouse data
  defp score(report, type) when type in ["performance", "seo", "accessibility", "best-practices", "pwa"] do
    case report.data["lighthouseResult"]["categories"][type]["score"] do
      nil -> 0
      _ -> (report.data["lighthouseResult"]["categories"][type]["score"] * 100) |> round()
    end
  end

  # Do not show issues with passing scores, or those that are not applicable,
  # require manual checking, or are purely informative.
  defp extract_issues(report) do
    report.data["lighthouseResult"]["audits"]
    |> Enum.reject(fn({_desc, item}) -> item["score"] == 1 end)
    |> Enum.reject(fn({_desc, item}) -> item["scoreDisplayMode"] == "notApplicable" end)
    |> Enum.reject(fn({_desc, item}) -> item["scoreDisplayMode"] == "manual" end)
    |> Enum.reject(fn({_desc, item}) -> item["scoreDisplayMode"] == "informative" end)
    |> Map.new()
  end
end
