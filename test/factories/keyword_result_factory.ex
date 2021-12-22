defmodule Kwtool.KeywordResultFactory do
  defmacro __using__(_opts) do
    quote do
      def keyword_result_factory do
        %Kwtool.Crawler.Schemas.KeywordResult{
          top_ads_count: 2,
          top_ads_urls: ["https://google.com", "https://example.com"],
          all_ads_count: 2,
          organic_result_count: 2,
          organic_result_urls: ["https://google.com", "https://example.com"],
          all_links_count: 2,
          html: "<html><head><title>crawler</title></head><body>News sites</body></html>",
          keyword: build(:keyword)
        }
      end
    end
  end
end
