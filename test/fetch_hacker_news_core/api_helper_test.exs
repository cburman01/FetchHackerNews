defmodule ApiHelperTests do
  use ExUnit.Case

  test "get top 50 posts" do
    assert {:ok, posts} = FetchHackerNewsCore.ApiHelper.get_top_posts()
  end

  test "combine post with content" do
    data =
      FetchHackerNewsCore.ApiHelper.get_top_posts()
      |> FetchHackerNewsCore.ApiHelper.combine_with_post_content()

    assert is_list(data)
  end
end
