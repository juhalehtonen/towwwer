defmodule Towwwer.Notifications.Slack do
  @moduledoc """
  Contains functions to handle Notifications sent via Slack.
  """

  @doc """
  Sends Slack message via specified webhook
  """
  def send_message(message) do
    url = slack_webhook_url()

    if url != nil do
      body = Jason.encode!(%{text: message})
      headers = [{"Content-type", "application/json"}]
      HTTPoison.post(url, body, headers, [])
    end
  end

  # Returns Slack webhook URL if configured, or nil otherwise
  @spec slack_webhook_url() :: String.t() | nil
  defp slack_webhook_url do
    Application.get_env(:towwwer, :slack_webhook_url) || System.get_env("SLACK_WEBHOOK_URL")
  end
end
