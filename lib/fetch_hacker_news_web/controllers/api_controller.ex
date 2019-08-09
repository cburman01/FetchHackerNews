defmodule FetchHackerNewsWeb.ApiController do
  use FetchHackerNewsWeb, :controller

  def get_top_posts(conn, %{"page" => pg} = _params) do
    {int_pg, _} = Integer.parse(pg)
    case FetchHackerNewsCore.StateServer.get_posts_by_page(int_pg) do
        {:ok, data} -> json(conn, data)
        {:error, reason} -> send_error_resp(conn, reason)
    end
  end

  def get_top_posts(conn, _params) do
    case FetchHackerNewsCore.StateServer.get_state() do
        {:ok, data} -> json(conn, data)
        {:error, reason} -> send_error_resp(conn, reason)
    end
 end

  def get_single_post(conn, %{"id" => id} = _params) do
    {int_id, _} = Integer.parse(id)
    case FetchHackerNewsCore.StateServer.get_single_post(int_id) do
        {:ok, data} -> json(conn, data)
        {:error, reason} -> send_error_resp(conn, reason)
    end
  end

  defp send_error_resp(conn, error) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(500, Jason.encode!(error))
    |> halt
  end
end
