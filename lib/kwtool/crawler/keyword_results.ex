defmodule Kwtool.Crawler.KeywordResults do
  import Ecto.Query, warn: false

  alias Kwtool.Account.Schemas.User
  alias Kwtool.Crawler.Queries.KeywordResultQuery
  alias Kwtool.Repo

  def search(%User{id: user_id}, params) do
    user_id
    |> KeywordResultQuery.search_query(params)
    |> Repo.all()
  end
end
