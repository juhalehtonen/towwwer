defmodule Towwwer.Tools.Helpers do
  @moduledoc """
  Contains helper functions and functions that do not yet have a clear home.
  """

  require Logger
  alias Towwwer.Tools.ApiClient
  alias Towwwer.Tools.WPScan
  alias Towwwer.Websites
  alias Towwwer.Notifications.Slack

  @doc """
  Generate a random URL-friendly string of given `length`.
  """
  @spec random_string(integer()) :: String.t()
  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
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
      MapDiff.diff(old_report_scores, new_report_scores)
      |> Map.get(:value)
      |> Enum.map(fn {_strategy, data} ->
        if Map.has_key?(data, :changed) && data.changed == :map_change do
          only_changes =
            Enum.filter(data.value, fn {_key, value} ->
              if value.changed == :primitive_change do
                true
              else
                false
              end
            end)

          Enum.map(only_changes, fn {key, value} ->
            item_values = %{new_value: value.added, old_value: value.removed}
            # Determine difference and direction
            {difference, direction} =
              cond do
                item_values.new_value > item_values.old_value ->
                  diff = (item_values.new_value - item_values.old_value) |> Float.round(3)
                  {diff, :increase}

                item_values.new_value < item_values.old_value ->
                  diff = (item_values.old_value - item_values.new_value) |> Float.round(3)
                  {diff, :decrease}
              end

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
      end)

    difference
  end

  @doc """
  Check for the score difference of two subsequent reports.
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

        if desktop_diff != nil do
          handle_significant_score_change(desktop_diff, site, monitor, "Desktop")
        end

        if mobile_diff != nil do
          handle_significant_score_change(mobile_diff, site, monitor, "Mobile")
        end
      end
    end)
  end

  # Handle diffs bigger than defined value
  @spec handle_significant_score_change(list(), map(), map(), String.t()) :: :ok
  defp handle_significant_score_change(diff, site, monitor, strategy) do
    Enum.each(diff, fn item ->
      if item.difference > 0.1 do
        emoji_strategy =
          case strategy do
            "mobile" -> ":iphone:"
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
            :decrease -> "-"
          end

        site_url = TowwwerWeb.Router.Helpers.site_path(TowwwerWeb.Endpoint, :show, site.id)

        difference_score = (item.difference * 100) |> round()

        message =
          "#{emoji_direction} #{site.base_url}#{monitor.path} #{emoji_strategy} #{item.type} *#{
            msg_direction
          }#{difference_score}* - #{site_url}"

        Logger.info(message)
        Slack.send_message(message)
      end
    end)
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
