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

  def vuln_url(vuln) do
    if Map.get(vuln, "references") |> Map.get("url") do
      vuln
      |> Map.get("references")
      |> Map.get("url")
      |> Enum.at(0)
    else
      ""
    end
  end

  def vulns(monitor) do
    report = Enum.at(monitor.reports, 0)

    report.wpscan_data["plugins"]
    |> Enum.filter(fn {_plugin_name, plugin_data} ->
      if plugin_data["vulnerabilities"] do
        vulns = plugin_data["vulnerabilities"]
        vulns != [] && vulns != nil
      else
        false
      end
    end)
  end
end
