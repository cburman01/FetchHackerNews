defmodule FetchHackerNewsWeb.ApiController do
  use FetchHackerNewsWeb, :controller

  def get_top_posts(conn, %{"page" => pg} = _params) do
    with {int_pg, _} <- Integer.parse(pg),
         {:ok, data} <- FetchHackerNewsCore.StateServer.get_posts_by_page(int_pg) do
      json(conn, data)
    end
  end

  def get_top_posts(conn, _params) do
    with {:ok, data} <- FetchHackerNewsCore.StateServer.get_state() do
      json(conn, data)
    end
  end

  def get_single_post(conn, %{"id" => id} = _params) do
    with {int_id, _} <- Integer.parse(id),
         {:ok, data} <- FetchHackerNewsCore.StateServer.get_single_post(int_id) do
      json(conn, data)
    end
  end
end
