defmodule TowwwerWeb.SiteController do
  use TowwwerWeb, :controller
  use PlugEtsCache.Phoenix

  alias Towwwer.Websites
  alias Towwwer.Websites.Site
  alias Towwwer.Websites.Monitor

  def index(conn, _params) do
    sites = Websites.list_sites_with_latest_root_report()

    conn
    |> render("index.html", sites: sites)
    |> cache_response()
  end

  def new(conn, _params) do
    changeset =
      Websites.change_site(%Site{
        monitors: [
          %Monitor{path: "/"}
        ]
      })

    conn
    |> render("new.html", changeset: changeset)
    |> cache_response()
  end

  def create(conn, %{"site" => site_params}) do
    case Websites.create_site(site_params) do
      {:ok, site} ->
        conn
        |> put_flash(:info, "Site created successfully.")
        |> redirect(to: Routes.site_path(conn, :show, site))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    site = Websites.get_site!(id)

    conn
    |> render("show.html", site: site)
    |> cache_response()
  end

  def edit(conn, %{"id" => id}) do
    site = Websites.get_site!(id)
    changeset = Websites.change_site(site)
    render(conn, "edit.html", site: site, changeset: changeset)
  end

  def update(conn, %{"id" => id, "site" => site_params}) do
    site = Websites.get_site!(id)

    case Websites.update_site(site, site_params) do
      {:ok, site} ->
        conn
        |> put_flash(:info, "Site updated successfully.")
        |> redirect(to: Routes.site_path(conn, :show, site))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", site: site, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    site = Websites.get_site!(id)
    {:ok, _site} = Websites.delete_site(site)

    conn
    |> put_flash(:info, "Site deleted successfully.")
    |> redirect(to: Routes.site_path(conn, :index))
  end
end
