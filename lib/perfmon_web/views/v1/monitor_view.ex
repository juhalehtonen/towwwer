defmodule PerfMonWeb.V1.MonitorView do
  use PerfMonWeb, :view
  alias PerfMonWeb.V1.MonitorView
  alias PerfMonWeb.V1.ReportView

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
      reports: render_many(monitor.reports, ReportView, "report.json"),
    }
  end
end
