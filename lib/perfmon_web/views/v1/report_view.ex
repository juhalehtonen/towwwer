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
      # id: report.id,
      performance: score(report, "performance"),
      seo: score(report, "seo"),
      accessibility: score(report, "accessibility"),
      bestPractices: score(report, "best-practices"),
      pwa: score(report, "pwa")
      # restaurants: render_many(report.restaurants, RestaurantView, "restaurant_ids.json"),
      # visits: render_many(report.visits, VisitView, "visit_ids.json")
    }
  end

  # Score extracted from saved lighthouse data
  defp score(report, type) when type in ["performance", "seo", "accessibility", "best-practices", "pwa"] do
    case report.data["lighthouseResult"]["categories"][type]["score"] do
      nil -> 0
      _ -> (report.data["lighthouseResult"]["categories"][type]["score"] * 100) |> round()
    end
  end
end
