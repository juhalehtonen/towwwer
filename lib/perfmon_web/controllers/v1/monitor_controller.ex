defmodule PerfMonWeb.V1.MonitorController do
  use PerfMonWeb, :controller

  alias PerfMon.Websites
  alias PerfMon.Websites.Monitor

  action_fallback PerfMonWeb.FallbackController

  def index(conn, _params) do
    monitors = Websites.list_monitors()
    render(conn, "index.json", monitors: monitors)
  end

  def create(conn, %{"monitor" => monitor_params}) do
    with {:ok, %Monitor{} = monitor} <- Websites.create_monitor(monitor_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_monitor_path(conn, :show, monitor))
      |> render("show.json", monitor: monitor)
    end
  end

  def show(conn, %{"id" => id}) do
    monitor = Websites.get_monitor!(id)
    render(conn, "show.json", monitor: monitor)
  end

  def update(conn, %{"id" => id, "monitor" => monitor_params}) do
    monitor = Websites.get_monitor!(id)

    with {:ok, %Monitor{} = monitor} <- Websites.update_monitor(monitor, monitor_params) do
      render(conn, "show.json", monitor: monitor)
    end
  end

  def delete(conn, %{"id" => id}) do
    monitor = Websites.get_monitor!(id)

    with {:ok, %Monitor{}} <- Websites.delete_monitor(monitor) do
      send_resp(conn, :no_content, "")
    end
  end
end
