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

    test "returns invalid when given invalid attributes" do
      changeset = Keyword.changeset(%{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               phrase: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end
  end
end
