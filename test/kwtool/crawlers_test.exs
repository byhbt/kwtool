defmodule Kwtool.CrawlersTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Crawlers
  alias Kwtool.Crawlers.Schemas.Keyword

  describe "save_keywords_list/2" do
    test "inserts the uploaded keywords to database" do
      created_user = insert(:user)
      keyword_file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

      assert {:ok, "The keyword file is processed successfully!"} =
               Crawlers.save_keywords_list(keyword_file, created_user)

      [keyword1, keyword2, keyword3] = Repo.all(Keyword)

      assert keyword1.phrase == "badminton racket"
      assert keyword1.user_id == created_user.id
      assert keyword2.phrase == "table tennis bat"
      assert keyword2.user_id == created_user.id
      assert keyword3.phrase == "golf club"
      assert keyword3.user_id == created_user.id
    end
  end

  describe "create_keyword/1" do
    test "creates a new keyword with valid data" do
      created_user = insert(:user)

      valid_attrs = %{
        phrase: "some phrase",
        raw_result: "some raw_result",
        status: 1,
        user_id: created_user.id
      }

      assert {:ok, %Keyword{} = keyword} = Crawlers.create_keyword(valid_attrs)
      assert keyword.phrase == "some phrase"
      assert keyword.raw_result == "some raw_result"
      assert keyword.status == 1
    end

    test "returns error changeset when provides invalid data" do
      invalid_attrs = %{phrase: nil, raw_result: nil, status: nil}

      assert {:error, %Ecto.Changeset{}} = Crawlers.create_keyword(invalid_attrs)
    end
  end
end
