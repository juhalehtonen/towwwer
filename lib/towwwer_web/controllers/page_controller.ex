defmodule TowwwerWeb.PageController do
  use TowwwerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  # TODO: Do this in Ecto, don't be an idiot :D
  def insights(conn, _params) do
    sites =
      Towwwer.Websites.list_sites_with_latest_root_report()
      |> Enum.filter(fn site ->
        first_monitor = Enum.at(site.monitors, 0)

        # Do we have reports?
        case first_monitor.reports do
          [] ->
            false

          _ ->
            first_report = Enum.at(first_monitor.reports, 0)

            # Is wpscan not aborted?
            if Map.has_key?(first_report.wpscan_data, "scan_aborted") do
              false
            else
              true
            end
        end
      end)

    render(conn, "insights.html", sites: sites)
  end
end