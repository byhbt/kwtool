defmodule Kwtool.Crawlers do
  import Ecto.Query, warn: false

  alias Kwtool.Accounts.Schemas.User
  alias Kwtool.Crawlers.UploadParser
  alias Kwtool.Crawlers.Schemas.Keyword
  alias Kwtool.Repo

  def save_keywords_list(keyword_file, %User{} = user) do
    UploadParser.load_from_file(keyword_file)
      |> Enum.each(fn keyword ->
      keyword_params = %{phrase: List.first(keyword), status: 0, user_id: user.id}

      create_keyword(keyword_params)
    end)

    {:ok, "The keyword file is processed successfully!"}
  end

  def list_keywords do
    Repo.all(Keyword)
  end

  def create_keyword(attrs \\ %{}) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end
end
