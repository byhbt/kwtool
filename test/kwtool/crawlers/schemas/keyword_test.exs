defmodule Kwtool.Crawlers.Schemas.UserTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Crawlers.Schemas.Keyword

  describe "changeset/2" do
    test "returns valid keyword changeset when given valid attributes" do
      keyword_params = %{phrase: "elixir", status: "added", user_id: 1}
      changeset = Keyword.changeset(keyword_params)

      assert changeset.valid?
      assert changeset.changes.phrase == "elixir"
      assert changeset.changes.status == "added"
      assert changeset.changes.user_id == 1
    end

    test "sets default status added when given no status attribute in advance" do
      keyword_params = %{phrase: "elixir", user_id: 1}
      changeset = Keyword.changeset(keyword_params)

      assert changeset.valid?
      assert changeset.changes.phrase == "elixir"
      assert changeset.changes.status == "added"
      assert changeset.changes.user_id == 1
    end

    test "returns the updated status name when given the status" do
      keyword_params = %{phrase: "elixir", user_id: 1, status: "in_process"}
      changeset = Keyword.changeset(%Kwtool.Crawlers.Schemas.Keyword{}, keyword_params)

      assert changeset.valid?
      assert changeset.changes.phrase == "elixir"
      assert changeset.changes.status == "in_process"
      assert changeset.changes.user_id == 1
    end

    test "returns the error of user association when given a not existed user in database" do
      keyword_params = %{phrase: "elixir", user_id: 1, status: "added"}

      {:error, changeset} =
        %Keyword{}
        |> Keyword.changeset(keyword_params)
        |> Repo.insert()

      refute changeset.valid?
      assert errors_on(changeset) == %{user: ["does not exist"]}
    end

    test "returns changeset errors when given invalid attributes" do
      changeset = Keyword.changeset(%{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               phrase: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end
  end
end
