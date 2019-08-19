defmodule FetchHackerNewsCore.StateServerSupervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: :state_server_supervisor)
  end

  @impl true
  def init([]) do
    children = [
      {FetchHackerNewsCore.StateServer, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
