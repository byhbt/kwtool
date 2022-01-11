defmodule Kwtool.Crawler.Schemas.KeywordResultTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Crawler.Schemas.KeywordResult

  describe "create_changeset/2" do
    test "returns valid keyword when given valid attributes" do
      keyword = insert(:keyword)
      keyword_params = params_for(:keyword_result, keyword: keyword)

      changeset = KeywordResult.create_changeset(keyword_params)

      assert changeset.valid? == true

      assert changeset.changes == %{
               all_ads_count: 2,
               all_links_count: 2,
               organic_result_count: 2,
               organic_result_urls: ["https://google.com", "https://example.com"],
               top_ads_count: 2,
               top_ads_urls: ["https://google.com", "https://example.com"],
               keyword_id: keyword.id,
               html: "<html><head><title>crawler</title></head><body>News sites</body></html>"
             }
    end

    test "returns the error of user association when given a not existed user in database" do
      keyword_params = params_for(:keyword_result, keyword: nil, keyword_id: 999)

      changeset = KeywordResult.create_changeset(keyword_params)

      assert {:error, changeset} = Repo.insert(changeset)
      assert errors_on(changeset) == %{keyword: ["does not exist"]}
    end

    test "returns changeset errors when given invalid attributes" do
      changeset = KeywordResult.create_changeset(%{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               all_ads_count: ["can't be blank"],
               all_links_count: ["can't be blank"],
               keyword_id: ["can't be blank"],
               organic_result_count: ["can't be blank"],
               organic_result_urls: ["can't be blank"],
               top_ads_count: ["can't be blank"],
               top_ads_urls: ["can't be blank"],
               html: ["can't be blank"]
             }
    end
  end
end
