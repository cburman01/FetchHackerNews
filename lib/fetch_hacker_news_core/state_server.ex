defmodule FetchHackerNewsCore.StateServer do
  use GenServer
  require Logger
  import FetchHackerNewsCore.ApiHelper

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: :state_server)
  def init(seed), do: {:ok, seed}

  #   Public API
  def update_state(data) do
    case get_pid() do
      nil -> {:error, "Unable to fetch data. State Server down."}
      pid -> GenServer.cast(pid, {:update, data})
    end
  end

  def get_state() do
    case get_pid() do
      nil -> {:error, "Unable to fetch data. State Server down."}
      pid -> GenServer.call(pid, :get)
    end
  end

  def get_single_post(id) do
    case get_pid() do
      nil -> {:error, "Unable to fetch data. State Server down."}
      pid -> GenServer.call(pid, {:get, id})
    end
  end

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

  defp get_pid(), do: GenServer.whereis(:state_server)

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
