defmodule FetchHackerNewsCore.StateServer do
  use GenServer
  require Logger
  import FetchHackerNewsCore.ApiHelper

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: :state_server)
  def init(seed), do: {:ok, seed}

  #   Public API
  def update_state(data), do: GenServer.cast(:state_server, {:update, data})

  def get_state(), do: GenServer.call(:state_server, :get)

  def get_single_post(id), do: GenServer.call(:state_server, {:get, id})

  def get_posts_by_page(pg) when pg > 0 do
    case get_state() do
      {:ok, posts} ->
        data =
          posts
          |> Enum.chunk_every(10)
          |> Enum.at(pg - 1)

        {:ok, data}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_posts_by_page(_pg), do: {:error, "Page must be greater than 0"}

  def handle_cast({:update, data}, state) when data == state, do: {:noreply, data}

  def handle_cast({:update, data}, _state) do
    Logger.info("DATA CHANGE! Broadcast!")
    FetchHackerNewsWeb.RoomChannel.broadcast_update(data)
    {:noreply, data}
  end

  def handle_call(:get, _from, state), do: {:reply, {:ok, state}, state}

  def handle_call({:get, id}, _from, state),
    do: {:reply, {:ok, Enum.filter(state, &(&1["id"] == id))}, state}
end
