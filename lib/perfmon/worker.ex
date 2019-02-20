defmodule PerfMon.Worker do
  use GenServer
  alias PerfMon.Tools.PageSpeed
  alias PerfMon.Websites

  # How long to wait (in milliseconds) between each report creation check.
  # 60 * 60 * 12 * 1000 = run these every 12 hours
  @periodic_wait 60 * 60 * 12 * 1000

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(state) do
    do_work()
    schedule_work()
    {:ok, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, @periodic_wait)
  end

  def handle_info(:work, state) do
    spawn_link(&do_work/0)
    schedule_work()
    {:noreply, state}
  end

  defp do_work() do
    loop_sites_for_reports()
  end

  defp loop_sites_for_reports do
    sites = Websites.list_pending_sites()

    for site <- sites do
      PageSpeed.run_build_task_for_site_monitors(site)
    end
  end
end
