defmodule Kwtool.KeywordResultsTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Crawler.KeywordResults

  describe "search/2" do
    test "given an existing keyword, returns the matching keyword result" do
      user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: keyword)

      [keyword_result] = KeywordResults.search(user, %{keyword: "coffee"})

      assert Enum.count(keyword_result.keyword_results) == 1
      assert keyword.id == keyword_result.id
      assert keyword.phrase == "coffee"
    end

    test "given an existing keyword with Url, returns the matching keyword and url" do
      user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: keyword, organic_result_urls: ["https://star-coffee.com"])

      [keyword_result] = KeywordResults.search(user, %{keyword: "coffee", url: "star-coffee.com"})

      assert Enum.count(keyword_result.keyword_results) == 1
      assert keyword.id == keyword_result.id
      assert keyword.phrase == "coffee"
    end

    test "given an existing keyword has multiple crawl results, returns the matching keyword and url" do
      user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: keyword, organic_result_urls: ["https://star-coffee.com"])
      insert(:keyword_result, keyword: keyword, organic_result_urls: ["https://black-coffee.com"])

      [keyword_result] = KeywordResults.search(user, %{keyword: "coffee", url: "coffee"})

      assert Enum.count(keyword_result.keyword_results) == 2
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

    test "given an empty param, returns an empty list" do
      user = insert(:user)

      assert KeywordResults.search(user, %{}) == []
    end

    test "given a keyword does NOT exist, returns an empty list" do
      user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: keyword, all_ads_count: 12)

      assert KeywordResults.search(user, %{keyword: "latte"}) == []
    end
  end
end
