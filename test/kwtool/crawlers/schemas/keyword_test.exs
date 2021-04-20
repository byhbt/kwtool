defmodule Kwtool.Crawlers.Schemas.UserTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Crawlers.Schemas.Keyword

  describe "keyword/2" do
    test "returns valid keyword changeset when given valid attributes" do
      keyword_params = %{phrase: "elixir", status: 1, user: 1}
      changeset = Keyword.changeset(keyword_params)

      assert changeset.valid?
      assert changeset.changes.phrase == "elixir"
    end
  end
end
