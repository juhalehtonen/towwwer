defmodule PerfMonWeb.ReportController do
  use PerfMonWeb, :controller

  alias PerfMon.Websites
  alias PerfMon.Websites.Report

  def index(conn, _params) do
    reports = Websites.list_reports()
    render(conn, "index.html", reports: reports)
  end

  def new(conn, _params) do
    changeset = Websites.change_report(%Report{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"report" => report_params}) do
    case Websites.create_report(report_params) do
      {:ok, report} ->
        conn
        |> put_flash(:info, "Report created successfully.")
        |> redirect(to: Routes.report_path(conn, :show, report))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    report = Websites.get_report!(id)
    render(conn, "show.html", report: report)
  end

  def edit(conn, %{"id" => id}) do
    report = Websites.get_report!(id)
    changeset = Websites.change_report(report)
    render(conn, "edit.html", report: report, changeset: changeset)
  end

  def update(conn, %{"id" => id, "report" => report_params}) do
    report = Websites.get_report!(id)

    case Websites.update_report(report, report_params) do
      {:ok, report} ->
        conn
        |> put_flash(:info, "Report updated successfully.")
        |> redirect(to: Routes.report_path(conn, :show, report))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", report: report, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    report = Websites.get_report!(id)
    {:ok, _report} = Websites.delete_report(report)

    conn
    |> put_flash(:info, "Report deleted successfully.")
    |> redirect(to: Routes.report_path(conn, :index))
  end
end
