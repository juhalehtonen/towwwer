defmodule TowwwerWeb.V1.MonitorView do
  use TowwwerWeb, :view
  alias TowwwerWeb.V1.MonitorView
  alias TowwwerWeb.V1.ReportView

  def render("index.json", %{monitors: monitors}) do
    %{data: render_many(monitors, MonitorView, "monitor.json")}
  end

  def render("show.json", %{monitor: monitor}) do
    %{data: render_one(monitor, MonitorView, "monitor.json")}
  end

  def render("monitor.json", %{monitor: monitor}) do
    %{
      id: monitor.id,
      site_id: monitor.site_id,
      path: monitor.path,
      reports: render_many(Enum.sort(monitor.reports), ReportView, "report.json"),
    }
  end
end
