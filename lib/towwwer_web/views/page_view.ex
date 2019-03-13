defmodule TowwwerWeb.PageView do
  use TowwwerWeb, :view

  def findings(monitor) do
    report = Enum.at(monitor.reports, 0)
    report.wpscan_data["interesting_findings"]
  end

  def core_version(monitor) do
    report = Enum.at(monitor.reports, 0)

    if report.wpscan_data["version"] do
      report.wpscan_data["version"]["number"]
    else
      ""
    end
  end

  def core_vulns(monitor) do
    report = Enum.at(monitor.reports, 0)

    if report.wpscan_data["version"] do
      core_info = report.wpscan_data["version"]
      core_info["vulnerabilities"]
    else
      []
    end
  end

  def vulns(monitor) do
    report = Enum.at(monitor.reports, 0)

    report.wpscan_data["plugins"]
    |> Enum.filter(fn({_plugin_name, plugin_data}) ->
      current_plugin_version = plugin_data["version"]
      current_vulnerabilities = current_plugin_version["vulnerabilities"]
      current_vulnerabilities != [] && current_vulnerabilities != nil
    end)
  end
end
