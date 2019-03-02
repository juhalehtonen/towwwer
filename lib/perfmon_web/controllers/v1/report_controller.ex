defmodule PerfMonWeb.V1.ReportController do
  use PerfMonWeb, :controller

  alias PerfMon.Websites
  alias PerfMon.Websites.Report

  action_fallback PerfMonWeb.FallbackController

  def index(conn, _params) do
    reports = Websites.list_reports()
    render(conn, "index.json", reports: reports)
  end

  def create(conn, %{"report" => report_params}) do
    with {:ok, %Report{} = report} <- Websites.create_report(report_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_report_path(conn, :show, report))
      |> render("show.json", report: report)
    end
  end

  def show(conn, %{"id" => id}) do
    report = Websites.get_report!(id)
    render(conn, "show.json", report: report)
  end

  def update(conn, %{"id" => id, "report" => report_params}) do
    report = Websites.get_report!(id)

    with {:ok, %Report{} = report} <- Websites.update_report(report, report_params) do
      render(conn, "show.json", report: report)
    end
  end

  def delete(conn, %{"id" => id}) do
    report = Websites.get_report!(id)

    with {:ok, %Report{}} <- Websites.delete_report(report) do
      send_resp(conn, :no_content, "")
    end
  end
end
