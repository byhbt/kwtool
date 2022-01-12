defmodule Kwtool.Crawler.Providers.GoogleTest do
  use KwtoolWeb.ConnCase, async: true

  alias Kwtool.Providers.Google.Crawler

  describe "crawl_keyword/1" do
    test "given valid keyword, returns 200 status code" do
      use_cassette "google/search_success" do
        {:ok, response} = Crawler.crawl_keyword("oven fryer")

        assert response.status == 200
      end
    end
  end
end
