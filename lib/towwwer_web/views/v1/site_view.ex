defmodule TowwwerWeb.V1.SiteView do
  use TowwwerWeb, :view
  alias TowwwerWeb.V1.SiteView
  alias TowwwerWeb.V1.ReportView
  alias TowwwerWeb.V1.MonitorView

  def render("index.json", %{sites: sites}) do
    %{data: render_many(sites, SiteView, "site.json")}
  end

  def render("show.json", %{site: site}) do
    %{data: render_one(site, SiteView, "site.json")}
  end

  def render("site.json", %{site: site}) do
    %{
      id: site.id,
      base_url: site.base_url,
      monitors: render_many(site.monitors, MonitorView, "monitor.json"),
    }
  end
end
