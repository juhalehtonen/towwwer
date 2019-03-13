defmodule Towwwer.Tools.WPScan do
  @moduledoc """
  Contains functions used to interact with the separately installed
  WPScan tool.
  """

  @doc """
  Run WPScan against the given `url` with default settings.
  TODO: Check if System.cmd actually runs properly.
  """
  @spec run(String.t()) :: {:ok, any()}
  def run(url) when is_binary(url) do
    {cmd, _} = System.cmd("wpscan", ["--no-banner", "--force", "---no-update", "--format", "json", "--url", url], parallelism: true)
    {:ok, cmd}
  end
  def run(_url), do: {:error, "URL not a binary"}
end
