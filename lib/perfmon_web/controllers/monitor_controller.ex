defmodule PerfMonWeb.MonitorController do
  use PerfMonWeb, :controller

  alias PerfMon.Websites
  alias PerfMon.Websites.Monitor

  def index(conn, _params) do
    monitors = Websites.list_monitors()
    render(conn, "index.html", monitors: monitors)
  end

  def new(conn, _params) do
    changeset = Websites.change_monitor(%Monitor{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"monitor" => monitor_params}) do
    case Websites.create_monitor(monitor_params) do
      {:ok, monitor} ->
        conn
        |> put_flash(:info, "Monitor created successfully.")
        |> redirect(to: Routes.monitor_path(conn, :show, monitor))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    monitor = Websites.get_monitor!(id)
    render(conn, "show.html", monitor: monitor)
  end

  def edit(conn, %{"id" => id}) do
    monitor = Websites.get_monitor!(id)
    changeset = Websites.change_monitor(monitor)
    render(conn, "edit.html", monitor: monitor, changeset: changeset)
  end

  def update(conn, %{"id" => id, "monitor" => monitor_params}) do
    monitor = Websites.get_monitor!(id)

    case Websites.update_monitor(monitor, monitor_params) do
      {:ok, monitor} ->
        conn
        |> put_flash(:info, "Monitor updated successfully.")
        |> redirect(to: Routes.monitor_path(conn, :show, monitor))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", monitor: monitor, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    monitor = Websites.get_monitor!(id)
    {:ok, _monitor} = Websites.delete_monitor(monitor)

    conn
    |> put_flash(:info, "Monitor deleted successfully.")
    |> redirect(to: Routes.monitor_path(conn, :index))
  end
end
