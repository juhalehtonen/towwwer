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

    get "/", PageController, :index
    resources "/reports", ReportController
    resources "/monitors", MonitorController
    resources "/domains", DomainController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PerfMonWeb do
  #   pipe_through :api
  # end
end
