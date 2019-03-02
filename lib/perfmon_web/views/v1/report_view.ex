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
      # restaurants: render_many(report.restaurants, RestaurantView, "restaurant_ids.json"),
      # visits: render_many(report.visits, VisitView, "visit_ids.json")
    }
  end
end
