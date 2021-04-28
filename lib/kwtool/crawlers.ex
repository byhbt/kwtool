defmodule Kwtool.Crawlers do
  import Ecto.Query, warn: false

  alias Kwtool.Accounts.Schemas.User
  alias Kwtool.Crawlers.Schemas.Keyword
  alias Kwtool.Crawlers.UploadParser
  alias Kwtool.Repo

  def save_keywords_list(%Plug.Upload{content_type: "text/csv"} = keyword_file, %User{} = user) do
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

  def save_keywords_list(_, _) do
    {:error, :file_is_invalid}
  end

  defp create_keyword(attrs) do
    %Keyword{}
    |> Keyword.create_changeset(attrs)
    |> Repo.insert()
  end
end
