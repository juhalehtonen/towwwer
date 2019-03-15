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
    # TODO: Check if site has wp_content_dir or wp_plugins_dir set, and use them.
    {cmd, _} = System.cmd("wpscan", ["--no-banner", "--force", "--no-update", "--format", "json", "--url", url], parallelism: true)
    {:ok, cmd}
  end
  def run(_site, _url), do: {:error, "URL not a binary"}
end
