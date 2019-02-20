defmodule PerfMonWeb.SiteView do
  use PerfMonWeb, :view

  def score(report, type) when type in ["performance", "seo", "accessibility", "best-practices", "pwa"] do
    case report.data["lighthouseResult"]["categories"][type]["score"] do
      nil -> 0
      _ -> report.data["lighthouseResult"]["categories"][type]["score"] * 100 |> round()
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
end
