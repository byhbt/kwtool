defmodule Kwtool.Crawler.Providers.Google.Parser do
  @selectors %{
    top_ads_count: "#tads .uEierd",
    top_ads_urls: ".x2VHCd.OSrXXb.nMdasd.qzEoUe",
    all_ads_count: ".x2VHCd.OSrXXb.qzEoUe",
    organic_result_urls: ".yuRUbf > a",
    organic_result_count: ".yuRUbf",
    all_links_count: "a[href]"
  }

  def parse(raw_html) do
    {_, document} = Floki.parse_document(raw_html)

    attributes = %{
      top_ads_count: top_ads_count(document),
      top_ads_urls: top_ads_urls(document),
      all_ads_count: total_ads_count(document),
      organic_result_count: organic_result_count(document),
      organic_result_urls: organic_result_urls(document),
      all_links_count: all_links_count(document),
      html: raw_html
    }

    {:ok, attributes}
  end

  defp top_ads_count(document) do
    document
    |> Floki.find(@selectors.top_ads_count)
    |> Enum.count()
  end

  defp all_links_count(document) do
    document
    |> Floki.find(@selectors.all_links_count)
    |> Enum.count()
  end

  defp organic_result_count(document) do
    document
    |> Floki.find(@selectors.organic_result_count)
    |> Enum.count()
  end

  defp organic_result_urls(document) do
    document
    |> Floki.find(@selectors.organic_result_urls)
    |> Floki.attribute("href")
  end

  defp top_ads_urls(document) do
    document
    |> Floki.find(@selectors.top_ads_urls)
    |> Enum.map(fn item -> Floki.text(item) end)
  end

  defp total_ads_count(document) do
    document
    |> Floki.find(@selectors.all_ads_count)
    |> Enum.count()
  end
end
