defmodule FetchHackerNewsCore.DataFetcher do
  use GenServer
  require Logger
  import FetchHackerNewsCore.ApiHelper
  @timeout 300_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(seed) do
    schedule_loop(2000)
    {:ok, seed}
  end

  defp schedule_loop(timeout), do: Process.send_after(self(), :loop, timeout)

  def handle_info(:loop, state) do
    get_top_posts()
    |> combine_with_post_content()
    |> FetchHackerNewsCore.StateServer.update_state()

    schedule_loop(@timeout)
    {:noreply, state}
  end
end
