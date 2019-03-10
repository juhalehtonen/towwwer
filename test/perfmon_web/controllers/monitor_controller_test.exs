defmodule TowwwerWeb.MonitorControllerTest do
  use TowwwerWeb.ConnCase

  alias Towwwer.Websites

  @create_attrs %{path: "some path"}
  @update_attrs %{path: "some updated path"}
  @invalid_attrs %{path: nil}

  def fixture(:monitor) do
    {:ok, monitor} = Websites.create_monitor(@create_attrs)
    monitor
  end

  describe "index" do
    test "lists all monitors", %{conn: conn} do
      conn = get(conn, Routes.monitor_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Monitors"
    end
  end

  describe "new monitor" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.monitor_path(conn, :new))
      assert html_response(conn, 200) =~ "New Monitor"
    end
  end

  describe "create monitor" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.monitor_path(conn, :create), monitor: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.monitor_path(conn, :show, id)

      conn = get(conn, Routes.monitor_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Monitor"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.monitor_path(conn, :create), monitor: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Monitor"
    end
  end

  describe "edit monitor" do
    setup [:create_monitor]

    test "renders form for editing chosen monitor", %{conn: conn, monitor: monitor} do
      conn = get(conn, Routes.monitor_path(conn, :edit, monitor))
      assert html_response(conn, 200) =~ "Edit Monitor"
    end
  end

  describe "update monitor" do
    setup [:create_monitor]

    test "redirects when data is valid", %{conn: conn, monitor: monitor} do
      conn = put(conn, Routes.monitor_path(conn, :update, monitor), monitor: @update_attrs)
      assert redirected_to(conn) == Routes.monitor_path(conn, :show, monitor)

      conn = get(conn, Routes.monitor_path(conn, :show, monitor))
      assert html_response(conn, 200) =~ "some updated path"
    end

    test "renders errors when data is invalid", %{conn: conn, monitor: monitor} do
      conn = put(conn, Routes.monitor_path(conn, :update, monitor), monitor: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Monitor"
    end
  end

  describe "delete monitor" do
    setup [:create_monitor]

    test "deletes chosen monitor", %{conn: conn, monitor: monitor} do
      conn = delete(conn, Routes.monitor_path(conn, :delete, monitor))
      assert redirected_to(conn) == Routes.monitor_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.monitor_path(conn, :show, monitor))
      end
    end
  end

  defp create_monitor(_) do
    monitor = fixture(:monitor)
    {:ok, monitor: monitor}
  end
end
