defmodule TowwwerWeb.SiteControllerTest do
  use TowwwerWeb.ConnCase

  alias Towwwer.Websites

  @create_attrs %{name: "some name", token: "some token"}
  @update_attrs %{name: "some updated name", token: "some updated token"}
  @invalid_attrs %{name: nil, token: nil}

  def fixture(:site) do
    {:ok, site} = Websites.create_site(@create_attrs)
    site
  end

  describe "index" do
    test "lists all sites", %{conn: conn} do
      conn = get(conn, Routes.site_path(conn, :index))
      assert html_response(conn, 200) =~ "Websites"
    end
  end

  describe "new site" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.site_path(conn, :new))
      assert html_response(conn, 200) =~ "<form"
    end
  end

  describe "create site" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.site_path(conn, :create), site: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.site_path(conn, :show, id)

      conn = get(conn, Routes.site_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Site"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.site_path(conn, :create), site: @invalid_attrs)
      assert html_response(conn, 200) =~ "Please check the errors below"
    end
  end

  describe "edit site" do
    setup [:create_site]

    test "renders form for editing chosen site", %{conn: conn, site: site} do
      conn = get(conn, Routes.site_path(conn, :edit, site))
      assert html_response(conn, 200) =~ "Edit Site"
    end
  end

  describe "update site" do
    setup [:create_site]

    test "redirects when data is valid", %{conn: conn, site: site} do
      conn = put(conn, Routes.site_path(conn, :update, site), site: @update_attrs)
      assert redirected_to(conn) == Routes.site_path(conn, :show, site)

      conn = get(conn, Routes.site_path(conn, :show, site))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, site: site} do
      conn = put(conn, Routes.site_path(conn, :update, site), site: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Site"
    end
  end

  describe "delete site" do
    setup [:create_site]

    test "deletes chosen site", %{conn: conn, site: site} do
      conn = delete(conn, Routes.site_path(conn, :delete, site))
      assert redirected_to(conn) == Routes.site_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.site_path(conn, :show, site))
      end
    end
  end

  defp create_site(_) do
    site = fixture(:site)
    {:ok, site: site}
  end
end
