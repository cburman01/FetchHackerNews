defmodule FetchHackerNewsWeb.Router do
  use FetchHackerNewsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FetchHackerNewsWeb do
    pipe_through :api
    get("/get_top_posts", ApiController, :get_top_posts)
    get("/get_single_post", ApiController, :get_single_post)
  end
end
