defmodule TowwwerWeb.Router do
  use TowwwerWeb, :router

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

  scope "/", TowwwerWeb do
    pipe_through :browser

    get "/", SiteController, :index
    get "/insights", PageController, :insights
    resources "/sites", SiteController
    # resources "/monitors", MonitorController, only: [:show]
    # resources "/reports", ReportController, only: [:show]
  end

  # Other scopes may use custom stacks.
  scope "/api", TowwwerWeb, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/sites", SiteController, except: [:new, :edit]
      resources "/monitors", MonitorController, except: [:new, :edit]
      resources "/reports", ReportController, except: [:new, :edit]
    end
  end
end
