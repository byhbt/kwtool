defmodule Kwtool.Crawlers do
  import Ecto.Query, warn: false

  alias Kwtool.Crawlers.Schemas.Keyword
  alias Kwtool.Repo
  alias NimbleCSV.RFC4180, as: CSV

  def import_from_file(keyword_file, user) do
    keyword_file.path
    |> File.stream!
    |> CSV.parse_stream(skip_headers: false)
    |> Enum.each(fn keyword ->
      keyword_params = %{phrase: List.first(keyword), status: 0, user: user.id}
      create_keyword(keyword_params)
    end)

    {:ok, "The keyword file is processed successfully!"}
  end

  def list_keywords do
    Repo.all(Keyword)
  end

  def get_keyword!(id), do: Repo.get!(Keyword, id)

  def create_keyword(attrs \\ %{}) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end

  def update_keyword(%Keyword{} = keyword, attrs) do
    keyword
    |> Keyword.changeset(attrs)
    |> Repo.update()
  end

  def delete_keyword(%Keyword{} = keyword) do
    Repo.delete(keyword)
  end

  def change_keyword(%Keyword{} = keyword, attrs \\ %{}) do
    Keyword.changeset(keyword, attrs)
  end
end
