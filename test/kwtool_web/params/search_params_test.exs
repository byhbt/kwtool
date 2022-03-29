defmodule KwtoolWeb.SearchParamsTest do
  use Kwtool.DataCase, async: true

  alias KwtoolWeb.Api.V1.SearchParams

  describe "changeset/2" do
    test "given valid params, returns a valid changeset" do
      params = %{
        url: "kwtool.co",
        min_ads: 1,
        keyword: "iPhone"
      }

      changeset = SearchParams.changeset(params)

      assert changeset.valid? == true

      assert changeset.changes == %{
               url: "kwtool.co",
               min_ads: 1,
               keyword: "iPhone"
             }
    end

    test "given invalid params, returns a valid changeset" do
      changeset = SearchParams.changeset(%{})

      assert changeset.valid? == false
      assert errors_on(changeset) == %{keyword: ["can't be blank"]}
    end
  end
end
