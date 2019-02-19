defmodule PerfMonWeb.SiteView do
  use PerfMonWeb, :view

  def score(report, type) when type in ["performance", "seo", "accessibility", "best-practices", "pwa"] do
    case report.data["lighthouseResult"]["categories"][type]["score"] do
      nil -> 0
      _ -> report.data["lighthouseResult"]["categories"][type]["score"] * 100 |> round()
    end
  end
end
