defmodule PerfMonWeb.SiteView do
  use PerfMonWeb, :view
  alias PerfMon.Websites.Site
  alias PerfMon.Websites.Monitor

  # Score extracted from saved lighthouse data
  def score(report, type) when type in ["performance", "seo", "accessibility", "best-practices", "pwa"] do
    case report.data["lighthouseResult"]["categories"][type]["score"] do
      nil -> 0
      _ -> (report.data["lighthouseResult"]["categories"][type]["score"] * 100) |> round()
    end
  end

  # Returns total size of monitor from report
  def total_size(report) do
    report.data["lighthouseResult"]["audits"]["total-byte-weight"]["displayValue"]
  end

  def first_meaningful_paint(report) do
    case report.data["lighthouseResult"]["audits"]["metrics"]["details"]["items"] do
      nil -> ""
      val -> val |> Enum.at(0) |> Map.get("firstMeaningfulPaint")
    end
  end

  def time_to_interactive(report) do
    case report.data["lighthouseResult"]["audits"]["metrics"]["details"]["items"] do
      nil -> ""
      val -> val |> Enum.at(0) |> Map.get("interactive")
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

  # Timestamp of when last automated reports were generated
  def last_automated_reports do
    PerfMon.Worker.get_state()
    |> NaiveDateTime.truncate(:second)
  end

  # Timestamp for when next automated reports will be generated
  def next_automated_reports do
    timestamp_last = last_automated_reports()
    timestamp_now = NaiveDateTime.utc_now()
    periodic_wait = PerfMon.Worker.periodic_wait()
    diff_in_ms = NaiveDateTime.diff(timestamp_now, timestamp_last, :millisecond)
    wait_minus_diff = periodic_wait - diff_in_ms

    NaiveDateTime.add(NaiveDateTime.utc_now(), wait_minus_diff, :millisecond)
    |> NaiveDateTime.truncate(:second)
  end

  def reports_of_monitor(monitor) do
    PerfMon.Websites.list_reports_of_monitor(monitor)
  end

  def generate_token do
    PerfMon.Tools.Helpers.random_string(32)
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
      true        -> "#FF851B"
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
