defmodule PerfMon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      PerfMon.Repo,
      # Start the endpoint when the application starts
      PerfMonWeb.Endpoint,
      {Task.Supervisor, name: PerfMon.TaskSupervisor, restart: :transient},
      # Starts a worker by calling: PerfMon.Worker.start_link(arg)
      {PerfMon.Worker, NaiveDateTime.utc_now()},
    ]

    # Start the ExternalService fuse
    ExternalService.start(PerfMon.Tools.ApiClient)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PerfMon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PerfMonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
