defmodule Kwtool.Providers.Google.Parser do
  @selectors %{
    top_ads_count: "#tads .uEierd",
    top_ads_urls: ".x2VHCd .OSrXXb .qzEoUe",
    all_ads_count: ".x2VHCd .OSrXXb .qzEoUe",
    organic_result_urls: ".yuRUbf > a",
    organic_result_count: ".yuRUbf",
    all_links_count: "a[href]"
  }

  def parse(html) do
    {_, document} = Floki.parse_document(html)

    attributes = %{
      top_ads_count: top_ads_count(document),
      top_ads_urls: top_ads_urls(document),
      all_ads_count: total_ads_count(document),
      organic_result_count: organic_result_count(document),
      organic_result_urls: organic_result_urls(document),
      all_links_count: all_links_count(document),
      html: html
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
    |> Floki.attribute("href")
  end

  defp total_ads_count(document) do
    document
    |> Floki.find(@selectors.top_ads_urls)
    |> Enum.count()
  end
end