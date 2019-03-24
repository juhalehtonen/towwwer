defmodule TowwwerWeb.SiteView do
  use TowwwerWeb, :view
  alias Towwwer.Websites.Site
  alias Towwwer.Websites.Monitor

  # Score extracted from saved lighthouse data
  def score(report, type, strategy \\ "desktop")
      when type in ["performance", "seo", "accessibility", "best-practices", "pwa"] and strategy in ["desktop", "mobile"] do

    case strategy do
      "desktop" ->
        case report.data["lighthouseResult"]["categories"][type]["score"] do
          nil -> 0
          _ -> (report.data["lighthouseResult"]["categories"][type]["score"] * 100) |> round()
        end
      "mobile" ->
        case report.mobile_data["lighthouseResult"]["categories"][type]["score"] do
          nil -> 0
          _ -> (report.mobile_data["lighthouseResult"]["categories"][type]["score"] * 100) |> round()
        end
    end
  end

  # Returns total size of monitor from report
  def total_size(report) do
    report.data["lighthouseResult"]["audits"]["total-byte-weight"]["displayValue"]
    |> String.replace("Total size was", "")
  end

  def first_meaningful_paint(report, strategy \\ "desktop") when strategy in ["desktop", "mobile"] do
    case strategy do
      "desktop" ->
        case report.data["lighthouseResult"]["audits"]["metrics"]["details"]["items"] do
          nil -> ""
          val -> val |> Enum.at(0) |> Map.get("firstMeaningfulPaint")
        end
      "mobile" ->
        case report.mobile_data["lighthouseResult"]["audits"]["metrics"]["details"]["items"] do
          nil -> ""
          val -> val |> Enum.at(0) |> Map.get("firstMeaningfulPaint")
        end
    end
  end

  def time_to_interactive(report, strategy \\ "desktop") when strategy in ["desktop", "mobile"] do
    case strategy do
      "desktop" ->
        case report.data["lighthouseResult"]["audits"]["metrics"]["details"]["items"] do
          nil -> ""
          val -> val |> Enum.at(0) |> Map.get("interactive")
        end
      "mobile" ->
        case report.mobile_data["lighthouseResult"]["audits"]["metrics"]["details"]["items"] do
          nil -> ""
          val -> val |> Enum.at(0) |> Map.get("interactive")
        end
    end
  end

  def robots_txt(report) do
    case report.data["lighthouseResult"]["audits"]["robots-txt"]["title"] do
      nil -> ""
      val -> val
    end
  end

  def final_screenshot(report) do
    case report.data["lighthouseResult"]["audits"]["final-screenshot"]["details"]["data"] do
      nil -> ""
      val -> val
    end
  end

  def wpscan_findings(monitor) do
    report = Enum.at(monitor.reports, 0)
    report.wpscan_data["interesting_findings"]
  end

  def reports_of_monitor(monitor) do
    Towwwer.Websites.list_reports_of_monitor(monitor)
  end

  def first_report(monitor) do
    Enum.at(monitor.reports, 0)
  end

  def generate_token do
    Towwwer.Tools.Helpers.random_string(32)
  end

  def link_to_monitor_fields do
    changeset = Site.changeset(%Site{monitors: [%Monitor{}]})
    form = Phoenix.HTML.FormData.to_form(changeset, [])
    fields = render_to_string(__MODULE__, "monitor_fields.html", f: form)

    link("Add Monitor",
      to: "#",
      "data-template": fields,
      id: "add_monitor",
      class: "button button-outline"
    )
  end

  def color_code_result(result) do
    cond do
      result < 45 -> "#FF4136"
      result > 74 -> "#2ECC40"
      true -> "#FF851B"
    end
  end

  def report_count(monitor) do
    monitor |> reports_of_monitor() |> length()
  end

  def message_no_reports(monitor) do
    cond do
      monitor |> report_count() > 0 -> ""
      true -> "No reports for this monitor have been created yet. Check back later."
    end
  end
end
