defmodule Kwtool.KeywordResultsTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Crawler.KeywordResults

  describe "search/2" do
    test "given an existing keyword, returns the matching keyword result" do
      user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: keyword)

      [keyword_result] = KeywordResults.search(user, %{keyword: "coffee"})

      assert keyword.id == keyword_result.id
      assert keyword.phrase == "coffee"
    end

    test "given an existing keyword with Url, returns the matching keyword and url" do
      user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: keyword, organic_result_urls: ["https://star-coffee.com"])

      [keyword_result] = KeywordResults.search(user, %{keyword: "coffee", url: "star-coffee.com"})

      assert keyword.id == keyword_result.id
      assert keyword.phrase == "coffee"
    end

    test "given an existing keyword with ads count, returns the matching keyword and ads count" do
      user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: keyword, all_ads_count: 13)

      [keyword_result] = KeywordResults.search(user, %{keyword: "coffee", min_ads: 12})

      assert keyword.id == keyword_result.id
      assert keyword.phrase == "coffee"
    end

    test "given a keyword does NOT exist, returns the matching keyword result" do
      user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: keyword, all_ads_count: 12)

      assert KeywordResults.search(user, %{keyword: "latte"}) == []
    end

    test "given an empty params, returns the matching keyword result" do
      user = insert(:user)

      assert_raise FunctionClauseError, fn ->
        KeywordResults.search(user, %{}) == []
      end
    end
  end
end
