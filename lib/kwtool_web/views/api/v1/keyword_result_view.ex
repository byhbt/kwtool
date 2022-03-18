defmodule KwtoolWeb.Api.V1.KeywordResultView do
  use JSONAPI.View, type: "keyword_result"

  def fields do
    [
      :top_ads_count,
      :top_ads_urls,
      :all_ads_count,
      :organic_result_count,
      :organic_result_urls,
      :all_links_count
    ]
  end
end
