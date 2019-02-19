defmodule PerfMonWeb.SiteController do
  use PerfMonWeb, :controller

  alias PerfMon.Websites
  alias PerfMon.Websites.Site
  alias PerfMon.Websites.Monitor

  def index(conn, _params) do
    sites = Websites.list_sites()
    render(conn, "index.html", sites: sites)
  end

  def new(conn, _params) do
    # changeset = Websites.change_site(%Site{})
    changeset = Websites.change_site(%Site{monitors: [
                                                  %Monitor{path: "/"}
                                                ]})
    render(conn, "new.html", changeset: changeset)
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
    render(conn, "show.html", site: site)
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
