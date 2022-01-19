defmodule Kwtool.Crawler.Providers.ParserTest do
  use KwtoolWeb.ConnCase, async: true

  alias Kwtool.Crawler.Providers.Google.{Crawler, Parser}

  describe "parse/1" do
    test "given HTML response contains ads, returns metrics" do
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

    test "given HTML response without ads, returns metrics" do
      use_cassette "google/crawl_no_ads" do
        {:ok, response} = Crawler.crawl_keyword("linux daterange:99992-99993")

        assert {:ok, metrics} = Parser.parse(response.body)

        assert %{
                 all_ads_count: 0,
                 all_links_count: 100,
                 html: _,
                 organic_result_count: 9,
                 organic_result_urls: [
                   "https://vi.wikipedia.org/wiki/Linux",
                   "https://www.thegioididong.com/hoi-dap/he-dieu-hanh-linux-la-gi-uu-nhuoc-diem-cua-he-dieu-hanh-1312530",
                   "https://www.linux.org/",
                   "https://phambinh.net/bai-viet/linux-la-gi-tai-sao-lap-trinh-vien-nen-biet-cach-su-dung-linux/",
                   "https://www.dienmayxanh.com/kinh-nghiem-hay/tim-hieu-ve-he-dieu-hanh-linux-596466",
                   "https://wiki.tino.org/he-dieu-hanh-linux-la-gi/",
                   "https://cellphones.com.vn/sforum/linux-he-dieu-hanh-mien-phi-nhung-la-dich-den-cua-tuong-lai",
                   "https://linuxmint.com/",
                   "https://viblo.asia/p/linux-that-tuyet-voi-XogBG2YrMxnL"
                 ],
                 top_ads_count: 0,
                 top_ads_urls: []
               } = metrics
      end
    end
  end
end
