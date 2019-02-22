defmodule PerfMon.Worker do
  use GenServer
  alias PerfMon.Tools.PageSpeed
  alias PerfMon.Websites

  # How long to wait (in milliseconds) between each report creation check.
  # 60 * 60 * 24 * 1000 = run these every 24 hours
  @periodic_wait 60 * 60 * 1 * 1000

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(state) do
    do_work()
    schedule_work()

    new_state = NaiveDateTime.utc_now()
    {:ok, new_state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, @periodic_wait)
  end

  def handle_info(:work, state) do
    spawn_link(&do_work/0)
    schedule_work()

    new_state = NaiveDateTime.utc_now()
    {:noreply, new_state}
  end

  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  defp do_work() do
    loop_sites_for_reports()
  end

  defp loop_sites_for_reports do
    sites = Websites.list_pending_sites()

    for site <- sites do
      PageSpeed.run_build_task_for_site_monitors(site)
    end
  end

  @doc """
  Helper function to return the state of the GenServer, representing the
  last time our automated report generation was run.
  """
  def get_state, do: GenServer.call(__MODULE__, :get_state)

  @doc """
  Return the @periodic_wait between automated runs, defined in milliseconds.
  """
  def periodic_wait, do: @periodic_wait
end
