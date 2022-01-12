defmodule MarketplaceWorker.Checkout.AirtableRecordCreatorTest do
  use Kwtool.DataCase, async: true
  use Oban.Testing, repo: Marketplace.Repo

  alias Kwtool.Crawler.Schemas.Keyword
  alias KwtoolWorker.Crawler.GoogleKeywordCrawler

  describe "perform/1" do
    test "given new keyword added to keywords table, returns :ok" do
      %Keyword{id: keyword_id} = insert(:keyword)

      use_cassette "google/crawl_success" do
        :ok = perform_job(GoogleKeywordCrawler, %{keyword_id: keyword_id})
      end
    end
  end
end
