defmodule TowwwerWeb.PageController do
  use TowwwerWeb, :controller
  use PlugEtsCache.Phoenix

  def index(conn, _params) do
    conn
    |> render("index.html")
    |> cache_response()
  end

  # Do this in Ecto, don't be an idiot :D
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
            is_wpscan_aborted?(first_report)
        end
      end)

    conn
    |> render("insights.html", sites: sites)
    |> cache_response()
  end

  defp is_wpscan_aborted?(report) do
    if Map.has_key?(report.wpscan_data, "scan_aborted") do
      false
    else
      true
    end
  end
end
