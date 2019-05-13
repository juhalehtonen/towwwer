defmodule Towwwer.Tools.Helpers do
  @moduledoc """
  Contains helper functions and functions that do not yet have a clear home.
  """

  require Logger
  alias Towwwer.Tools.ApiClient
  alias Towwwer.Tools.WPScan
  alias Towwwer.Websites
  alias Towwwer.Websites.Site
  alias Towwwer.Websites.Monitor
  alias Towwwer.Notifications.Slack

  @doc """
  Generate a random URL-friendly string of given `length`.
  """
  @spec random_string(integer()) :: String.t()
  def random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  @doc """
  Constructs and saves a new Report from the JSON based on the response of
  the PageSpeed API and WPScan results.
  """
  @spec build_report(map(), map()) :: {:ok, map()} | {:error, String.t()}
  def build_report(site, monitor) do
    url = site.base_url <> monitor.path

    with {:ok, body_d} <- ApiClient.get(url, "desktop"),
         {:ok, body_m} <- ApiClient.get(url, "mobile"),
         data_d <- Jason.decode!(body_d),
         data_m <- Jason.decode!(body_m),
         wpscan_data <- build_wpscan_data(site, monitor) do
      Websites.create_report(%{
        data: data_d,
        mobile_data: data_m,
        wpscan_data: wpscan_data,
        monitor: monitor
      })
    else
      {:error, reason} -> {:error, reason}
    end
  end

  # Only run WPScan against the root path, as the other paths are redundant.
  defp build_wpscan_data(site, monitor) do
    url = site.base_url <> monitor.path

    case monitor.path do
      "/" ->
        {:ok, cmd} = WPScan.run(site, url)
        Jason.decode!(cmd)

      _ ->
        nil
    end
  end

  @doc """
  Given two maps of report scores, compare them and determine if there is
  any significant difference in them, and whether they have gone up or down.

  Returns a list of lists in the form of [[desktop_data], [mobile_data]], or
  [nil, nil] if there are no differences in scores.
  """
  @spec compare_scores(map(), map()) :: [list() | list()] | [nil | nil]
  def compare_scores(old_report_scores, new_report_scores) do
    # Generate a diff of the two score maps
    difference =
      old_report_scores
      |> MapDiff.diff(new_report_scores)
      |> Map.get(:value)
      |> Enum.map(fn {_strategy, data} ->
        if Map.has_key?(data, :changed) && data.changed == :map_change do
          only_changes = filter_unchanged(data)
          list_changes(only_changes)
        end
      end)

    difference
  end

  # Filters out unchanged data
  defp filter_unchanged(data) do
    Enum.filter(data.value, fn {_key, value} -> primitive_change?(value) end)
  end

  # Returns a list of maps for changes
  @spec list_changes(list()) :: list()
  defp list_changes(list_of_changes) do
    Enum.map(list_of_changes, fn {key, value} ->
      item_values = %{new_value: value.added, old_value: value.removed}
      # Determine difference and direction
      {difference, direction} = difference_and_direction(item_values)

      %{
        type: key,
        added: value.added,
        changed: value.changed,
        removed: value.removed,
        direction: direction,
        difference: difference
      }
    end)
  end

  # Check for a primitive change in map
  defp primitive_change?(value) do
    if value.changed == :primitive_change do
      true
    else
      false
    end
  end

  # Return the difference and direction
  defp difference_and_direction(item_values) do
    cond do
      item_values.new_value > item_values.old_value ->
        diff = (item_values.new_value - item_values.old_value) |> Float.round(3)
        {diff, :increase}

      item_values.new_value < item_values.old_value ->
        diff = (item_values.old_value - item_values.new_value) |> Float.round(3)
        {diff, :decrease}

      true ->
        {:error, "No difference"}
    end
  end

  @doc """
  Check for the score difference of two subsequent reports.
  Gets called by the Rihanna job.
  """
  @spec check_score_diff(map(), map(), map(), map()) :: {:ok, pid()}
  def check_score_diff(prev_report, report, site, monitor) do
    Task.start(fn ->
      # If we actually had a previous report to compare to
      if prev_report != nil do
        # Compare scores of new and prev reports
        old_scores = Websites.get_report_scores!(prev_report.id)
        new_scores = Websites.get_report_scores!(report.id)
        [desktop_diff, mobile_diff] = compare_scores(old_scores, new_scores)

        handle_work_for_non_nil_diff(desktop_diff, site, monitor, "Desktop")
        handle_work_for_non_nil_diff(mobile_diff, site, monitor, "Mobile")
      end
    end)
  end

  # Handle checking for non-nil of diff
  @spec handle_work_for_non_nil_diff(list(), %Site{}, %Monitor{}, String.t()) :: any()
  defp handle_work_for_non_nil_diff(diff, site, monitor, strategy)
       when strategy in ["Desktop", "Mobile"] do
    if diff != nil do
      handle_significant_score_change(diff, site, monitor, strategy)
    end
  end

  # Handle diffs bigger than defined value
  @spec handle_significant_score_change(list(), %Site{}, %Monitor{}, String.t()) :: :ok
  defp handle_significant_score_change(diff, site, monitor, strategy) do
    Enum.each(diff, fn item ->
      if item.difference > 0.1 do
        site_url = live_url(site)
        difference_score = item.difference |> humanize_score()
        msg_parts = get_message_parts(strategy, item)
        current_score = item.added |> humanize_score()

        message =
          "#{msg_parts.emoji_direction} #{site.base_url}#{monitor.path} #{
            msg_parts.emoji_strategy
          } #{item.type} *#{msg_parts.msg_direction}#{difference_score}* (#{current_score}) - #{
            site_url
          }"

        Logger.info(message)
        Slack.send_message(message)
      end
    end)
  end

  # Check for specific things in the report, and send helpful messages
  # if those are detected.
  def check_low_hanging_fruits(site, monitor, report) do
    Task.start(fn ->
      if low_hanging_fruits?(report) do
        fruit_message = low_hanging_fruits_to_message(report)
        fruit_report = fruit_message <> " " <> "for #{site.base_url}#{monitor.path}"
        Logger.info(fruit_report)
        # Slack.send_message(fruit_report)
      end
    end)
  end

  # Checks if low-hanging fruits exist
  defp low_hanging_fruits?(report) do
    if report.data["lighthouseResult"]["audits"]["uses-optimized-images"]["score"] < 0.6 do
      true
    else
      false
    end
  end

  # Converts low-hanging fruits to Slack/log messages.
  defp low_hanging_fruits_to_message(report) do
    bytes_to_save =
      report.data["lighthouseResult"]["audits"]["uses-optimized-images"]["details"][
        "overallSavingsBytes"
      ]

    kilobytes_to_save = bytes_to_kilobytes(bytes_to_save)

    "You could save #{kilobytes_to_save} kilobytes by optimizing images"
  end

  defp bytes_to_kilobytes(bytes), do: bytes / 1000

  @doc """
  Returns the live_url if configured. This is useful when the application is served
  through a reverse proxy and the application doesn't actually know what URL it is
  behind.
  """
  def live_url(site) do
    case Application.get_env(:towwwer, :live_url) do
      nil ->
        TowwwerWeb.Router.Helpers.site_url(TowwwerWeb.Endpoint, :show, site.id)

      live_url ->
        live_url <> TowwwerWeb.Router.Helpers.site_path(TowwwerWeb.Endpoint, :show, site.id)
    end
  end

  @doc """
  Converts a float-based (0-1) PageSpeed score to a more commonly understood int (0-100).
  """
  @spec humanize_score(float()) :: integer()
  def humanize_score(score) do
    val = score * 100
    round(val)
  end

  # Given a value, return a corresponding part of the message to send/log.
  @spec get_message_parts(String.t(), map()) :: map()
  defp get_message_parts(strategy, item) do
    emoji_strategy =
      case strategy do
        "Mobile" -> ":iphone:"
        _ -> ":desktop_computer:"
      end

    emoji_direction =
      case item.direction do
        :increase -> ":heavy_check_mark:"
        _ -> ":rotating_light:"
      end

    msg_direction =
      case item.direction do
        :increase -> "+"
        _ -> "-"
      end

    %{
      emoji_strategy: emoji_strategy,
      emoji_direction: emoji_direction,
      msg_direction: msg_direction
    }
  end

  @doc """
  Runs a build task for each monitor under given `site`.
  """
  def run_build_task_for_site_monitors(site) when is_map(site) do
    for monitor <- site.monitors do
      Rihanna.schedule(Towwwer.Job, [site, monitor], in: :timer.seconds(5))
    end
  end

  @doc """
  Run a build task for every newly added site monitor, but not the existing
  ones.
  """
  def run_build_task_for_new_site_monitors(site) when is_map(site) do
    for monitor <- site.monitors do
      if monitor.updated_at == monitor.inserted_at do
        Rihanna.schedule(Towwwer.Job, [site, monitor], in: :timer.seconds(5))
      end
    end
  end
end
