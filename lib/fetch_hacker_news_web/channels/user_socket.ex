defmodule FetchHackerNewsWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", FetchHackerNewsWeb.RoomChannel
  transport(:websocket, Phoenix.Transports.WebSocket)
  
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
