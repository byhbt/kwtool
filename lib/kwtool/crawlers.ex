defmodule Kwtool.Crawlers do
  import Ecto.Query, warn: false

  alias Kwtool.Accounts.Schemas.User
  alias Kwtool.Crawlers.Schemas.Keyword
  alias Kwtool.Crawlers.UploadParser
  alias Kwtool.Repo

  def save_keywords_list(keyword_file, %User{} = user) do
    case UploadParser.parse(keyword_file) do
      {:ok, keyword_list} ->
        Enum.each(keyword_list, fn keyword ->
          create_keyword(%{
            phrase: List.first(keyword),
            user_id: user.id
          })
        end)

        {:ok, :file_is_proccessed}

      {:error, :file_is_empty} ->
        {:error, :file_is_empty}

      {:error, :file_is_invalid} ->
        {:error, :file_is_invalid}
    end
  end

  def paginate_user_keywords(%User{} = user, params \\ %{}) do
    user
    |> query_keyword_by_user()
    |> query_search_term(search_term)
    |> Repo.paginate(params)
  end

  def get_keyword_by_user(%User{} = user, keyword_id) do
    user
    |> query_keyword_by_user()
    |> where([k], k.id == ^keyword_id)
    |> Repo.one()
  end

  defp create_keyword(attrs) do
    %Keyword{}
    |> Keyword.create_changeset(attrs)
    |> Repo.insert()
  end

  defp query_keyword_by_user(%User{} = user) do
    where(Keyword, [k], k.user_id == ^user.id)
  end

  defp query_search_term(query, search_phrase) do
    wildcard_search = "%#{search_phrase}%"

    from k in query, where: ilike(k.phrase, ^wildcard_search)
  end
end
