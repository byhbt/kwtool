defmodule Kwtool.CrawlersTest do
  use Kwtool.DataCase

  alias Kwtool.Crawlers

  describe "keywords" do
    alias Kwtool.Crawlers.Keyword

    @valid_attrs %{phrase: "some phrase", raw_result: "some raw_result", status: 42}
    @update_attrs %{
      phrase: "some updated phrase",
      raw_result: "some updated raw_result",
      status: 43
    }
    @invalid_attrs %{phrase: nil, raw_result: nil, status: nil}

    def keyword_fixture(attrs \\ %{}) do
      {:ok, keyword} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Crawlers.create_keyword()

      keyword
    end

    test "list_keywords/0 returns all keywords" do
      keyword = keyword_fixture()
      assert Crawlers.list_keywords() == [keyword]
    end

    test "get_keyword!/1 returns the keyword with given id" do
      keyword = keyword_fixture()
      assert Crawlers.get_keyword!(keyword.id) == keyword
    end

    test "create_keyword/1 with valid data creates a keyword" do
      assert {:ok, %Keyword{} = keyword} = Crawlers.create_keyword(@valid_attrs)
      assert keyword.phrase == "some phrase"
      assert keyword.raw_result == "some raw_result"
      assert keyword.status == 42
    end

    test "create_keyword/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Crawlers.create_keyword(@invalid_attrs)
    end

    test "update_keyword/2 with valid data updates the keyword" do
      keyword = keyword_fixture()
      assert {:ok, %Keyword{} = keyword} = Crawlers.update_keyword(keyword, @update_attrs)
      assert keyword.phrase == "some updated phrase"
      assert keyword.raw_result == "some updated raw_result"
      assert keyword.status == 43
    end

    test "update_keyword/2 with invalid data returns error changeset" do
      keyword = keyword_fixture()
      assert {:error, %Ecto.Changeset{}} = Crawlers.update_keyword(keyword, @invalid_attrs)
      assert keyword == Crawlers.get_keyword!(keyword.id)
    end

    test "delete_keyword/1 deletes the keyword" do
      keyword = keyword_fixture()
      assert {:ok, %Keyword{}} = Crawlers.delete_keyword(keyword)
      assert_raise Ecto.NoResultsError, fn -> Crawlers.get_keyword!(keyword.id) end
    end

    test "change_keyword/1 returns a keyword changeset" do
      keyword = keyword_fixture()
      assert %Ecto.Changeset{} = Crawlers.change_keyword(keyword)
    end
  end
end
