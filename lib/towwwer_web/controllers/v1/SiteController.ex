defmodule TowwwerWeb.V1.SiteController do
  use TowwwerWeb, :controller

  alias Towwwer.Websites
  alias Towwwer.Websites.Site

  action_fallback TowwwerWeb.FallbackController

  def index(conn, _params) do
    sites = Websites.list_sites_with_latest_root_report()
    render(conn, "index.json", sites: sites)
  end

  def create(conn, %{"site" => site_params}) do
    with {:ok, %Site{} = site} <- Websites.create_site(site_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_site_path(conn, :show, site))
      |> render("show.json", site: site)
    end
  end

  def show(conn, %{"id" => id}) do
    site = Websites.get_site!(id)
    render(conn, "show.json", site: site)
  end

  def update(conn, %{"id" => id, "site" => site_params}) do
    site = Websites.get_site!(id)

    with {:ok, %Site{} = site} <- Websites.update_site(site, site_params) do
      render(conn, "show.json", site: site)
    end
  end

  def delete(conn, %{"id" => id}) do
    site = Websites.get_site!(id)

    with {:ok, %Site{}} <- Websites.delete_site(site) do
      send_resp(conn, :no_content, "")
    end
  end
end
