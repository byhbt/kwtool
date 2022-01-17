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

        keyword = Repo.get(Keyword, keyword_id)
        assert keyword.status == "finished"

        assert [keyword_result_in_db] = Repo.preload(keyword, :keyword_results).keyword_results

        assert %{
                 all_ads_count: 4,
                 all_links_count: 313,
                 html: _,
                 organic_result_count: 8,
                 organic_result_urls: [
                   "https://www.dienmayxanh.com/noi-chien-khong-dau",
                   "https://shopee.vn/search?keyword=n%E1%BB%93i%20chi%C3%AAn%20kh%C3%B4ng%20d%E1%BA%A7u",
                   "https://mediamart.vn/noi-chien-khong-dau",
                   "https://www.nguyenkim.com/noi-chien-khong-dau/",
                   "https://dienmaycholon.vn/tu-khoa/noi-chien-khong-dau",
                   "https://dienmaycholon.vn/noi-chien-noi-nuong",
                   "https://fptshop.com.vn/noi-chien-khong-dau",
                   "https://www.noichienkhongdau.com/"
                 ],
                 top_ads_count: 2,
                 top_ads_urls: [
                   "https://www.nguyenkim.com/",
                   "https://www.dienmaycholon.vn/nồi-chiên"
                 ]
               } = keyword_result_in_db
      end
    end
  end
end
