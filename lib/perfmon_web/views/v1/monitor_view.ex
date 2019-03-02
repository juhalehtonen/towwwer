defmodule PerfMonWeb.V1.MonitorView do
  use PerfMonWeb, :view
  alias PerfMonWeb.V1.MonitorView

  def render("index.json", %{monitors: monitors}) do
    %{data: render_many(monitors, MonitorView, "monitor.json")}
  end

  def render("show.json", %{monitor: monitor}) do
    %{data: render_one(monitor, MonitorView, "monitor.json")}
  end

  def render("monitor.json", %{monitor: monitor}) do
    %{
      id: monitor.id,
      path: monitor.path,
      # restaurants: render_many(monitor.restaurants, RestaurantView, "restaurant_ids.json"),
      # visits: render_many(monitor.visits, VisitView, "visit_ids.json")
    }
  end
end
