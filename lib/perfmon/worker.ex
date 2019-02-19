defmodule PerfMon.Worker do
  use GenServer
  alias PerfMon.Tools.PageSpeed
  alias PerfMon.Websites

  # How long to wait (in milliseconds) between each report creation.
  # 60 * 60 * 12 * 1000 = run these every 12 hours
  @periodic_wait 60 * 60 * 12 * 1000

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    spawn_link(&do_work/0)
    schedule_work()
    {:noreply, state}
  end

  defp do_work() do
    loop_sites_for_reports()
  end

  defp schedule_work() do
    Process.send_after(self(), :work, @periodic_wait)
  end

  # Loop through all sites and every monitor of every site
  def loop_sites_for_reports do
    sites = Websites.list_sites()
    for site <- sites do
      for monitor <- site.monitors do
        {:ok, _pid} = Task.Supervisor.start_child(PerfMon.TaskSupervisor, fn ->
          PageSpeed.build_report(site.base_url <> monitor.path, monitor)
        end)
      end
    end
  end
end
