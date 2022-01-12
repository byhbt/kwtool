defmodule Kwtool.Crawler.Providers.ParserTest do
  use KwtoolWeb.ConnCase, async: true

  alias Kwtool.Providers.Google.{Crawler, Parser}

  describe "crawl_keyword/1" do
    test "given HTML response, returns correct metrics" do
      use_cassette "google/crawl_success" do
        {:ok, response} = Crawler.crawl_keyword("noi chien khong dau")

        assert {:ok, metrics} = Parser.parse(response.body)

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
               } = metrics
      end
    end
  end
end
