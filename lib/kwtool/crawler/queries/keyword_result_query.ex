defmodule Kwtool.Crawler.Queries.KeywordResultQuery do
  import Ecto.Query, warn: false

  alias Kwtool.Crawler.Schemas.{Keyword, KeywordResult}

  def search_query(user_id, params) do
    Keyword
    |> join(:inner, [k], kr in KeywordResult, on: kr.keyword_id == k.id)
    |> where([k, _kr], k.user_id == ^user_id)
    |> maybe_search_by_keyword(params)
    |> maybe_search_by_url(params)
    |> maybe_search_by_ads(params)
    |> preload(:keyword_results)
  end

  def maybe_search_by_keyword(query, %{keyword: keyword}) do
    keyword_wildcard = "%#{keyword}%"

    where(query, [k, _kr], ilike(k.phrase, ^keyword_wildcard))
  end

  def maybe_search_by_keyword(query, _), do: query

  def maybe_search_by_url(query, %{url: url}) do
    url_wildcard = "%#{url}%"

    where(
      query,
      [_k, _kr],
      fragment("organic_result_urls ::text ilike ANY(array[?::text])", ^url_wildcard)
    )
  end

  def maybe_search_by_url(query, _), do: query

  def maybe_search_by_ads(query, %{min_ads: min_ads}) do
    where(query, [_k, kr], kr.all_ads_count >= ^min_ads)
  end

  def maybe_search_by_ads(query, _), do: query
end
