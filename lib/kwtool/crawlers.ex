defmodule Kwtool.Crawlers do
  import Ecto.Query, warn: false

  alias Kwtool.Accounts.Schemas.User
  alias Kwtool.Crawlers.Schemas.Keyword
  alias Kwtool.Crawlers.UploadParser
  alias Kwtool.Repo

  def save_keywords_list(keyword_file, %User{} = user) do
    keyword_file
    |> UploadParser.load_from_file()
    |> Enum.each(fn keyword ->
      create_keyword(%{
        phrase: List.first(keyword),
        status: 0,
        user_id: user.id
      })
    end)

    {:ok, "The keyword file is processed successfully!"}
  end

  def create_keyword(attrs \\ %{}) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end
end
