defmodule FetchHackerNewsWeb.FallbackController do
    use FetchHackerNewsWeb, :controller
    def call(conn, {:error, reason}) do
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(500, Jason.encode!(reason))
        |> halt
    end
  end