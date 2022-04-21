defmodule Kwtool.KeywordResultsTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Crawler.KeywordResults

  describe "search/2" do
    test "given an existing keyword, returns the matching keyword result" do
      user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: keyword)

      [expected_keyword] = KeywordResults.search(user, %{keyword: "coffee"})

      assert Enum.count(expected_keyword.keyword_results) == 1
      assert expected_keyword.id == keyword.id
      assert expected_keyword.phrase == "coffee"
    end

    test "given an existing keyword with url, returns the matching keyword and url" do
      user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: keyword, organic_result_urls: ["https://star-coffee.com"])

      not_included_keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)

      insert(:keyword_result,
        keyword: not_included_keyword,
        organic_result_urls: ["https://starbuck.com"]
      )

      [expected_keyword] = KeywordResults.search(user, %{keyword: "coffee", url: "star-coffee.com"})

      assert expected_keyword.id == keyword.id
      assert expected_keyword.phrase == "coffee"
    end

    test "given an existing keyword has multiple crawl results, returns the matching keyword and url" do
      user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: keyword, organic_result_urls: ["https://star-coffee.com"])
      insert(:keyword_result, keyword: keyword, organic_result_urls: ["https://black-coffee.com"])

      [expected_keyword] = KeywordResults.search(user, %{keyword: "coffee", url: "coffee"})

      assert Enum.count(expected_keyword.keyword_results) == 2
      assert expected_keyword.id == keyword.id
      assert expected_keyword.phrase == "coffee"
    end

    test "given an existing keyword with ads count, returns the matching keyword and ads count" do
      user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: keyword, all_ads_count: 13)

      not_included_keyword = insert(:keyword, phrase: "coffee", status: "finished", user: user)
      insert(:keyword_result, keyword: not_included_keyword, all_ads_count: 10)

      [expected_keyword] = KeywordResults.search(user, %{keyword: "coffee", min_ads: 12})

      assert expected_keyword.id == keyword.id
      assert expected_keyword.phrase == "coffee"
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
