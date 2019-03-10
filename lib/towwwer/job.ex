defmodule Towwwer.Job do
  @behaviour Rihanna.Job
  require Logger
  alias Towwwer.Websites
  alias Towwwer.Tools.Helpers

  @moduledoc """
  Enqueue job for later execution and return immediately:
  Rihanna.enqueue(Towwwer.Job, [arg1, arg2])

  To implement a recurring job have the job reschedule itself after completion
  and Postgres’ ACID guarantees will ensure that it continues running. You will
  need to enqueue the job manually the first time from the console.
  """

  @doc """
  NOTE: `perform/1` is a required callback. It takes exactly one argument. To
  pass multiple arguments, wrap them in a list and destructure in the
  function head as in this example.

  This has to return one of: :ok | {:ok, result} | :error | {:error, reason}
  """
  def perform([site, monitor]) do
    success? = do_work(site, monitor)

    case success? do
      :ok ->
        Rihanna.schedule(Towwwer.Job, [site, monitor], in: :timer.hours(24))
        :ok

      :error ->
        Rihanna.schedule(Towwwer.Job, [site, monitor], in: :timer.hours(1))
        {:error, :failed}
    end
  end

  defp do_work(site, monitor) do
    Logger.info("Doing work for #{site.base_url}")

    case Helpers.build_report(site.base_url <> monitor.path, monitor) do
      {:ok, _report} ->
        Logger.info("Created report for #{site.base_url} at #{monitor.path} successfully")
        Websites.bump_site_timestamp(site)
        :ok

      {:error, _changeset} ->
        Logger.info("Failed to create report for #{site.base_url} monitor #{monitor.path}")
        :error
    end
  end

  # Query all pending sites and run the build task for them.
  # Should only be called directly from console when initially setting things up.
  # Afterwards the jobs should already be enqueued and stored in PostgreSQL.
  def loop_sites_for_reports do
    sites = Websites.list_sites_with_preloads()

    for site <- sites do
      Helpers.run_build_task_for_site_monitors(site)
    end
  end
end
