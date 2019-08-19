defmodule FetchHackerNewsWeb.FallbackController do
    use Phoenix.Controller
    def call(conn, {:error, reason}) do
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(500, Jason.encode!(reason))
        |> halt
    end
    def call(conn, _error) do
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(500, Jason.encode!("An Error Occurred."))
        |> halt
    end
  end