defmodule Kwtool.Crawlers do
  import Ecto.Query, warn: false
  alias Kwtool.Repo

  alias Kwtool.Crawlers.Keyword

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
