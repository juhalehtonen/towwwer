defmodule PerfMon.Tools.WPScan do
  @moduledoc """
  Contains functions used to interact with the separately installed
  WPScan tool.
  """

  @doc """
  Run WPScan against the given `url` with default settings.
  """
  def run(url) when is_binary(url) do
    cmd = System.cmd("wpscan", ["--no-banner", "--format", "json", "--url", url], parallelism: true)
    {:ok, cmd}
  end
  def run(_url), do: {:error, "URL not a binary"}
end
