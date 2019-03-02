defmodule PerfMonWeb.Router do
  use PerfMonWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PerfMonWeb do
    pipe_through :browser

    get "/", SiteController, :index
    resources "/sites", SiteController
    # resources "/monitors", MonitorController, only: [:show]
    # resources "/reports", ReportController, only: [:show]
  end

  # Other scopes may use custom stacks.
  scope "/api", PerfMonWeb, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/monitors", MonitorController, except: [:new, :edit]
      resources "/reports", ReportController, except: [:new, :edit]
    end
  end
end
