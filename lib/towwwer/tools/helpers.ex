defmodule Towwwer.Tools.Helpers do
  @moduledoc """
  Contains helper functions and functions that do not yet have a clear home.
  """

  alias Towwwer.Tools.ApiClient
  alias Towwwer.Tools.WPScan
  alias Towwwer.Websites

  @doc """
  Generate a random URL-friendly string of given `length`.
  """
  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  @doc """
  Constructs and saves a new Report from the JSON based on the response of
  the PageSpeed API and WPScan results.
  """
  def build_report(url, monitor) do
    case ApiClient.get(url) do
      {:ok, body} ->
        data = Jason.decode!(body)

        # Only run WPScan against the root path, as the other paths are redundant.
        wpscan_data =
          case monitor.path do
            "/" ->
              {:ok, cmd} = WPScan.run(url)
              Jason.decode!(cmd)

            _ ->
              nil
          end

        Websites.create_report(%{data: data, wpscan_data: wpscan_data, monitor: monitor})

      {:error, reason} ->
        {:error, reason}
    end
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
