defmodule Kwtool.Crawler.Keywords do
  import Ecto.Query, warn: false

  alias Kwtool.Account.Schemas.User
  alias Kwtool.Crawler.Schemas.{Keyword, KeywordResult}
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

  def find_keyword_by_user(%User{} = user, keyword_id) do
    Keyword
    |> where([k], k.user_id == ^user.id)
    |> where([k], k.id == ^keyword_id)
    |> preload(:keyword_results)
    |> Repo.one()
  end

  def find_by_id!(keyword_id) do
    Keyword
    |> where(id: ^keyword_id)
    |> Repo.one!()
  end

  def add_crawl_result(%Keyword{id: keyword_id}, crawler_result_attrs) do
    crawler_result_attrs
    |> Map.put(:keyword_id, keyword_id)
    |> KeywordResult.create_changeset()
    |> Repo.insert()
  end

  def mark_as_finished(%Keyword{} = keyword) do
    keyword
    |> Keyword.finished_changeset()
    |> Repo.update()
  end

  defp create_keyword(attrs) do
    {:ok, %Keyword{id: keyword_id}} =
      %Keyword{}
      |> Keyword.create_changeset(attrs)
      |> Repo.insert()

    add_to_crawler_queue(keyword_id)
  end

  defp add_to_crawler_queue(keyword_id) do
    %{"keyword_id" => keyword_id}
    |> GoogleKeywordCrawler.new()
    |> Oban.insert()
  end
end
