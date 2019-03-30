defmodule TowwwerWeb.SiteTableLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    Current temperature: <%= @temperature %>
    """
  end

  def mount(_params, socket) do
    if connected?(socket), do: :timer.send_interval(5000, self(), :update)
    {:ok, assign(socket, temperature: 50)}
  end

  def handle_info(:update, socket) do
    old_temp = socket.assigns.temperature
    temperature = old_temp + 10
    {:noreply, assign(socket, :temperature, temperature)}
  end
end
