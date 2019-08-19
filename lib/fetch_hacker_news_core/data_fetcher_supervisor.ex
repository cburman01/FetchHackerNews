defmodule FetchHackerNewsCore.DataFetcherSupervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: :data_fetcher_supervisor)
  end

  @impl true
  def init([]) do
    children = [
      {FetchHackerNewsCore.DataFetcher, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
