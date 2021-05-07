defmodule Kwtool.CrawlersTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Crawlers
  alias Kwtool.Crawlers.Schemas.Keyword

  describe "save_keywords_list/2" do
    test "inserts the uploaded keywords to the database when given a valid CSV file" do
      created_user = insert(:user)
      keyword_file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

      assert {:ok, :file_is_proccessed} = Crawlers.save_keywords_list(keyword_file, created_user)
      assert [keyword1, keyword2, keyword3] = Repo.all(Keyword)

      assert keyword1.phrase == "badminton racket"
      assert keyword1.user_id == created_user.id
      assert keyword1.status == "added"
      assert keyword2.phrase == "table tennis bat"
      assert keyword2.user_id == created_user.id
      assert keyword2.status == "added"
      assert keyword3.phrase == "golf club"
      assert keyword3.user_id == created_user.id
      assert keyword3.status == "added"
    end
  end

  describe "paginate_user_keywords/2" do
    test "returns a list of keywords when given a user" do
      created_user = insert(:user)
      insert(:keyword, user: created_user)

      {keywords, pagination} = Crawlers.paginate_user_keywords(created_user, %{page: 1})

      assert length(keywords) == 1

      assert %Phoenix.Pagination{
               items: [],
               page: 1,
               params: %{page: 1},
               total_count: 1,
               total_pages: 1,
               max_page: 1000,
               per_page: 15
             } == pagination
    end

    test "returns a list of keywords which does NOT contain other user keyword" do
      created_user = insert(:user)
      insert(:keyword, user: created_user)

      created_user_2 = insert(:user)
      custom_keyword_attrs = %{phrase: "test listing per user phrase", user: created_user_2}
      keyword_of_user_2 = insert(:keyword, custom_keyword_attrs)

      {keywords, pagination} = Crawlers.paginate_user_keywords(created_user, %{page: 1})

      assert length(keywords) == 1
      refute Enum.at(keywords, 0).phrase == keyword_of_user_2.phrase

      assert %Phoenix.Pagination{
               items: [],
               page: 1,
               params: %{page: 1},
               total_count: 1,
               total_pages: 1,
               max_page: 1000,
               per_page: 15
             } == pagination
    end

    test "returns a list of matched keywords when given a query params" do
      created_user = insert(:user)
      custom_keyword_attrs = %{phrase: "test search param", user: created_user}

      insert(:keyword, user: created_user)
      insert(:keyword, custom_keyword_attrs)

      search_query = %{"query" => "test search param"}
      {keywords, _pagination} = Crawlers.paginate_user_keywords(created_user, search_query)

      assert length(keywords) == 1
      assert Enum.at(keywords, 0).phrase == custom_keyword_attrs.phrase
    end

    test "returns a empty list when given a not matched query params" do
      created_user = insert(:user)
      insert(:keyword, user: created_user)

      search_query = %{"query" => "not exist search phrase"}
      {keywords, _pagination} = Crawlers.paginate_user_keywords(created_user, search_query)

      assert keywords == []
    end
  end

  describe "get_keyword_by_user/2" do
    test "returns a keyword for a given user" do
      created_user = insert(:user)
      user_keyword = insert(:keyword, user: created_user)
      keyword = Crawlers.get_keyword_by_user(created_user, user_keyword.id)

      assert keyword.id == user_keyword.id
      assert keyword.phrase == user_keyword.phrase
    end

    test "returns nil when querying keyword of a different user" do
      created_user_1 = insert(:user)
      user_1_keyword = insert(:keyword, user: created_user_1)
      created_user_2 = insert(:user)

      assert Crawlers.get_keyword_by_user(created_user_2, user_1_keyword.id) == nil
    end
  end
end
