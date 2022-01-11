defmodule Kwtool.Crawlers do
  import Ecto.Query, warn: false

  alias Kwtool.Account.Schemas.User
  alias Kwtool.Crawler.Schemas.Keyword
  alias Kwtool.Crawler.UploadParser
  alias Kwtool.Repo
  alias KwtoolWorker.Crawler.GoogleKeywordCrawler

  def save_keywords_list(keyword_file, %User{} = user) do
    case UploadParser.parse(keyword_file) do
      {:ok, keyword_list} ->
        Enum.each(keyword_list, fn keyword ->
          create_keyword(%{
            phrase: List.first(keyword),
            user_id: user.id
          })
        end)

        {:ok, :file_is_processed}

      {:error, :file_is_empty} ->
        {:error, :file_is_empty}

      {:error, :file_is_invalid} ->
        {:error, :file_is_invalid}
    end
  end

  def paginate_user_keywords(%User{} = user, params \\ %{}) do
    search_phrase = get_in(params, ["query"])
    wildcard_search = "%#{search_phrase}%"

    Keyword
    |> where([k], k.user_id == ^user.id)
    |> where([k], ilike(k.phrase, ^wildcard_search))
    |> Repo.paginate(params)
  end

  def get_keyword_by_user(%User{} = user, keyword_id) do
    Keyword
    |> where([k], k.user_id == ^user.id)
    |> where([k], k.id == ^keyword_id)
    |> Repo.one()
  end

  defp create_keyword(attrs) do
    {:ok, %Keyword{id: keyword_id}} =
      %Keyword{}
      |> Keyword.create_changeset(attrs)
      |> Repo.insert()

    %{"keyword_id" => keyword_id}
    |> GoogleKeywordCrawler.new()
    |> Oban.insert()
  end
end
