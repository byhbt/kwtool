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

  describe "create_keyword/1" do
    test "creates a new keyword when given a valid params" do
      created_user = insert(:user)

      valid_attrs = %{
        phrase: "some phrase",
        raw_result: "some raw_result",
        status: "added",
        user_id: created_user.id
      }

      assert {:ok, %Keyword{} = keyword} = Crawlers.create_keyword(valid_attrs)
      assert keyword.phrase == "some phrase"
      assert keyword.raw_result == "some raw_result"
      assert keyword.status == "added"
    end

    test "returns an error changeset when provides an invalid params" do
      invalid_attrs = %{phrase: nil, raw_result: nil, status: nil}

      assert {:error, %Ecto.Changeset{}} = Crawlers.create_keyword(invalid_attrs)
    end
  end
end
