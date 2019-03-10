defmodule TowwwerWeb.PageView do
  use TowwwerWeb, :view

  def findings(monitor) do
    report = Enum.at(monitor.reports, 0)
    report.wpscan_data["interesting_findings"]
  end
end
