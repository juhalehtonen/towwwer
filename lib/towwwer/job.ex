defmodule Towwwer.Job do
  @behaviour Rihanna.Job
  require Logger
  alias Towwwer.Websites
  alias Towwwer.Tools.Helpers

  @moduledoc """
  Enqueue job for later execution and return immediately:
  Rihanna.enqueue(Towwwer.Job, [arg1, arg2])

  A recurring job is implemented by having the job reschedule itself after completion
  and Postgres’ ACID guarantees will ensure that it continues running.

  NOTE: You will need to enqueue the job manually the first time from the console.
  """

  @doc """
  NOTE: `perform/1` is a required callback. It takes exactly one argument. To pass
  multiple arguments, wrap them in a list and destructure in the function head.

  This has to return one of: :ok | {:ok, result} | :error | {:error, reason}
  """
  @spec perform([map() | map()]) :: :ok | {:error, :failed}
  def perform([site, monitor]) do
    success? = do_work(site, monitor)

    case success? do
      :ok ->
        naive_now = NaiveDateTime.utc_now()

        {:ok, naive_midnight} =
          NaiveDateTime.new(naive_now.year, naive_now.month, naive_now.day, 0, 0, 0)

        naive_next_midnight = NaiveDateTime.add(naive_midnight, 86400, :second)
        {:ok, next_midnight} = DateTime.from_naive(naive_next_midnight, "Etc/UTC")
        Rihanna.schedule(Towwwer.Job, [site, monitor], at: next_midnight)
        :ok

      :error ->
        Rihanna.schedule(Towwwer.Job, [site, monitor], in: :timer.hours(1))
        {:error, :failed}
    end
  end

  @spec do_work(map(), map()) :: :ok | :error
  defp do_work(site, monitor) do
    Logger.info("Doing work for #{site.base_url} at #{monitor.path}")

    # Get previous report in order to compare the upcoming one to this one
    prev_report = Websites.get_latest_report_for_monitor(monitor)

    case Helpers.build_report(site, monitor) do
      {:ok, report} ->
        Logger.info("Created report for #{site.base_url} at #{monitor.path} successfully")

        # TODO: Handle this comparison in a new process to ensure we do not crash here

        # If we actually had a previous report to compare to
        if prev_report != nil do
          # Compare scores of new and prev reports
          Logger.info("Comparing scores between reports #{prev_report.id} and #{report.id}")
          old_scores = Websites.get_report_scores!(prev_report.id)
          new_scores = Websites.get_report_scores!(report.id)
          [desktop_diff, mobile_diff] = Helpers.compare_scores(old_scores, new_scores)

          # TODO: Clean this up

          if desktop_diff != nil do
            Enum.each(desktop_diff, fn item ->
              if item.difference > 0.01 do
                Logger.info(
                  "Desktop #{item.type} changed to direction #{item.direction} by #{item.difference} for #{
                  site.base_url
                  } at #{monitor.path}"
                )
              end
            end)
          end

          if mobile_diff != nil do
            Enum.each(desktop_diff, fn item ->
              if item.difference > 0.01 do
                Logger.info(
                  "Mobile #{item.type} changed to direction #{item.direction} by #{item.difference} for #{
                  site.base_url
                  } at #{monitor.path}"
                )
              end
            end)
          end
        end

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
