defmodule Kwtool.Crawler.KeywordResults do
  import Ecto.Query, warn: false

  alias Kwtool.Account.Schemas.User
  alias Kwtool.Crawler.Schemas.{Keyword, KeywordResult}
  alias Kwtool.Repo

  def search(%User{} = user, params \\ %{}) do
    search_phrase = get_in(params, ["url"])
    url_wildcard = "%#{search_phrase}%"

    Keyword
    |> join(:inner, [k], kr in KeywordResult, on: kr.keyword_id == k.id)
    |> where([k], k.user_id == ^user.id)
    |> where([kr], fragment("organic_result_urls ::text ilike ANY(array[?::text])", ^url_wildcard))
    |> preload(:keyword_results)
    |> Repo.all()
  end
end
