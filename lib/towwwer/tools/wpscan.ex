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

  def run(_site, _url), do: {:error, "URL not a binary"}

  # Helper to construct the WPScan command
  # TODO: Just construct the param list, not the whole command
  @spec construct_wpscan_command(map(), String.t()) :: tuple()
  defp construct_wpscan_command(site, url) do
    {cmd, _} =
      cond do
        site.wp_content_dir != nil && site.wp_content_dir != "" && site.wp_plugins_dir != nil &&
            site.wp_plugins_dir != "" ->
          System.cmd(
            "wpscan",
            [
              "--no-banner",
              "--force",
              "--no-update",
              "--format",
              "json",
              "--wp-content-dir",
              site.wp_content_dir,
              "--wp-plugins-dir",
              site.wp_plugins_dir,
              "--url",
              url
            ],
            parallelism: true
          )

        site.wp_content_dir != nil && site.wp_content_dir != "" ->
          System.cmd(
            "wpscan",
            [
              "--no-banner",
              "--force",
              "--no-update",
              "--format",
              "json",
              "--wp-content-dir",
              site.wp_content_dir,
              "--url",
              url
            ],
            parallelism: true
          )

        site.wp_plugins_dir != nil && site.wp_plugins_dir != "" ->
          System.cmd(
            "wpscan",
            [
              "--no-banner",
              "--force",
              "--no-update",
              "--format",
              "json",
              "--wp-plugins-dir",
              site.wp_plugins_dir,
              "--url",
              url
            ],
            parallelism: true
          )

        true ->
          System.cmd(
            "wpscan",
            ["--no-banner", "--force", "--no-update", "--format", "json", "--url", url],
            parallelism: true
          )
      end

    {:ok, cmd}
  end
end
