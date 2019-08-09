defmodule DataFetcherTests do
  use ExUnit.Case

  test "start loop get data" do
    {:ok, data_pid} = GenServer.start(FetchHackerNewsCore.DataFetcher, [])
    {:ok, ss_pid} = GenServer.start(FetchHackerNewsCore.StateServer, [])
    Kernel.send(data_pid, :loop)
    Process.sleep(2000)

    assert FetchHackerNewsCore.StateServer.get_state() != []
  end
end
