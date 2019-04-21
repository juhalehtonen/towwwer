defmodule Towwwer.Tools.WPScan do
  @moduledoc """
  Contains functions used to interact with the separately installed
  WPScan tool.
  """

  @doc """
  Run WPScan against the given `url` with default settings.
  TODO: Check if System.cmd actually runs properly.
  """
  @spec run(map(), String.t()) :: {:ok, any()} | {:error, String.t()}
  def run(site, url) when is_map(site) and is_binary(url) do
    construct_wpscan_command(site, url)
  end

  def run(_site, _url), do: {:error, "URL not a binary or Site not a map"}

  # Helper to construct the WPScan command
  @spec construct_wpscan_command(map(), String.t()) :: tuple()
  defp construct_wpscan_command(site, url) do
    # See which params to pass to WPScan
    params =
      cond do
        # Both WP Content and WP Plugins directories are set
        both_directory_params_set?(site) ->
          base_params() ++ url_params(url) ++ wp_content_params(site) ++ wp_plugins_params(site)

        # WP Content directory is set
        site.wp_content_dir != nil && site.wp_content_dir != "" ->
          base_params() ++ url_params(url) ++ wp_content_params(site)

        # WP Plugins directory is set
        site.wp_plugins_dir != nil && site.wp_plugins_dir != "" ->
          base_params() ++ url_params(url) ++ wp_plugins_params(site)

        # No directories are set
        true ->
          base_params() ++ url_params(url)
      end

    # Run command with correct params
    {cmd, _} = System.cmd("wpscan", params, parallelism: true)
    {:ok, cmd}
  end

  # Check if both directory params are set
  defp both_directory_params_set?(site) do
    site.wp_content_dir != nil && site.wp_content_dir != "" && site.wp_plugins_dir != nil &&
      site.wp_plugins_dir != ""
  end

  # Returns a list of common base parameters used by all wpscan commands
  defp base_params do
    ["--no-banner", "--force", "--no-update", "--format", "json"]
  end

  # Returns a list of url parameters
  defp url_params(url) do
    ["--url", url]
  end

  # Returns a list of wp_content parameters
  defp wp_content_params(site) do
    ["--wp-content-dir", site.wp_content_dir]
  end

  # Returns a list of wp_plugins parameters
  defp wp_plugins_params(site) do
    ["--wp-plugins-dir", site.wp_plugins_dir]
  end
end
