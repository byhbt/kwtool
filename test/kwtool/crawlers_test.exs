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

  describe "get_user_keywords/2" do
    test "returns a list of keywords when given a user" do
      created_user = insert(:user)
      insert(:keyword, user: created_user)

      {keywords, pagination} = Crawlers.get_user_keywords(created_user)

      assert length(keywords) == 1

      assert %{
               items: [],
               page: 1,
               params: %{},
               total_count: 1,
               total_pages: 1
             } = pagination
    end
  end
end
