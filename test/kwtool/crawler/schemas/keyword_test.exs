defmodule Kwtool.Crawler.Schemas.KeywordTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Crawler.Schemas.Keyword

  describe "create_changeset/2" do
    test "returns valid keyword when given valid attributes" do
      keyword_params = %{phrase: "elixir", status: "added", user_id: 1}
      changeset = Keyword.create_changeset(keyword_params)

      assert changeset.valid?
      assert changeset.changes.phrase == "elixir"
      assert changeset.changes.status == "added"
      assert changeset.changes.user_id == 1
    end

    test "sets default status added when given no status attribute in advance" do
      keyword_params = %{phrase: "elixir", user_id: 1}
      changeset = Keyword.create_changeset(keyword_params)

      assert changeset.valid?
      assert changeset.changes.phrase == "elixir"
      assert changeset.changes.status == "added"
      assert changeset.changes.user_id == 1
    end

    test "returns the error of user association when given a not existed user in database" do
      keyword_params = %{phrase: "elixir", user_id: 1, status: "added"}

      {:error, changeset} =
        %Keyword{}
        |> Keyword.create_changeset(keyword_params)
        |> Repo.insert()

      refute changeset.valid?

      assert errors_on(changeset) == %{user: ["does not exist"]}
    end

    test "returns changeset errors when given invalid attributes" do
      changeset = Keyword.create_changeset(%{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               phrase: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end
  end

  describe "finished_changeset/2" do
    test "given the keyword with status `added`, returns it with the status is updated to `finished`" do
      keyword = insert(:keyword, status: "added")

      changeset = Keyword.finished_changeset(keyword)

      assert changeset.valid?
      assert changeset.changes.status == "finished"
    end
  end
end
