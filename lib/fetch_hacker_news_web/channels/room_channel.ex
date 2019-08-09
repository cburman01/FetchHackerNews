defmodule FetchHackerNewsWeb.RoomChannel do
  use FetchHackerNewsWeb, :channel
  require Logger

  def join("room:lobby", _payload, socket) do
    case FetchHackerNewsCore.StateServer.get_state() do
      {:ok, data} -> {:ok, data, socket}
      {:error, reason} -> {:error, %{reason: reason}}
    end
  end

  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def broadcast_update(data),
    do: FetchHackerNewsWeb.Endpoint.broadcast("room:lobby", "update", %{payload: data})
end
