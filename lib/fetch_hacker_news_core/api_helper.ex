defmodule FetchHackerNewsCore.ApiHelper do
  @moduledoc """
  Module to call HackerNews API's 
  """

  @doc """
  Get the top posts. Could be up to 500 and lmit to 50
  """
  def get_top_posts() do
    :httpc.request(:get, {'https://hacker-news.firebaseio.com/v0/topstories.json', []}, [], [])
    |> parse_response
    |> limit_posts
  end

  @doc """
  Get a single post from the HackerNews API
  """
  def get_post(id) do
    :httpc.request(:get, {'https://hacker-news.firebaseio.com/v0/item/#{id}.json', []}, [], [])
    |> parse_response
  end

  @doc """
  Marry post ID's with full post details
  """
  def combine_with_post_content({:ok, ids}) do
    Parallel.pmap(ids, fn id ->
      get_post(id)
    end)
    |> Enum.map(fn
      {:ok, post} ->
        post

      {:error, _reason} ->
        # Do something with the error maybe? Probably doesnt matter since next iteration will upate state 
        nil
    end)
    |> Enum.filter(&(&1 != nil))
  end

  def combine_with_post_content({:error, reason}), do: {:error, reason}

  @doc """
  Reduces the post count to 50
  """
  def limit_posts({:ok, posts}) when length(posts) > 50 do
    count_to_drop = abs(50 - Enum.count(posts))
    {:ok, Enum.drop(posts, count_to_drop)}
  end

  def limit_posts({:ok, posts}), do: {:ok, posts}
  def limit_posts({:error, reason}), do: {:error, reason}

  @doc """
  Parse and encode the http response
  """
  def parse_response({:ok, {{_, _, _}, _headers, body}}) do
    body
    |> Jason.decode()
  end

  def parse_response({:error, reason}), do: {:error, reason}
end
