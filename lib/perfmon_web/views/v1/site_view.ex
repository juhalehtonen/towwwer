defmodule PerfMonWeb.V1.SiteView do
  use PerfMonWeb, :view
  alias PerfMonWeb.V1.SiteView
  alias PerfMonWeb.V1.ReportView
  alias PerfMonWeb.V1.MonitorView

  def render("index.json", %{sites: sites}) do
    %{data: render_many(sites, SiteView, "site.json")}
  end

  def render("show.json", %{site: site}) do
    %{data: render_one(site, SiteView, "site.json")}
  end

  def render("site.json", %{site: site}) do
    %{
      id: site.id,
      monitors: render_many(site.monitors, MonitorView, "monitor.json"),
    }
  end
end
