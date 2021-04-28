defmodule Kwtool.Crawlers do
  import Ecto.Query, warn: false

  alias Kwtool.Accounts.Schemas.User
  alias Kwtool.Crawlers.Schemas.Keyword
  alias Kwtool.Crawlers.UploadParser
  alias Kwtool.Repo

  def save_keywords_list(keyword_file, %User{} = user) do
    case UploadParser.load_from_file(keyword_file) do
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
    end
  end

  defp create_keyword(attrs) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end
end
