defmodule Kwtool.Crawler.KeywordResults do
  import Ecto.Query, warn: false

  alias Kwtool.Account.Schemas.User
  # alias Kwtool.Crawler.Schemas.{Keyword, KeywordResult}
  alias Kwtool.Repo

  def search(%User{} = user, params \\ %{}) do
    search_phrase = get_in(params, ["query"])
    wildcard_search = "%#{search_phrase}%"

    Keyword
    |> where([k], k.user_id == ^user.id)
    |> where([k], ilike(k.phrase, ^wildcard_search))
    |> Repo.all()
  end
end
