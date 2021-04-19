defmodule KwtoolWeb.KeywordController do
  use KwtoolWeb, :controller

  alias Kwtool.Crawlers
  alias Kwtool.Crawlers.Schemas.Keyword

  def index(conn, _params) do
    keywords = Crawlers.list_keywords()
    render(conn, "index.html", keywords: keywords)
  end

  def new(conn, _params) do
    changeset = Crawlers.change_keyword(%Keyword{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"keyword" => keyword_params}) do
    case Crawlers.create_keyword(keyword_params) do
      {:ok, keyword} ->
        conn
        |> put_flash(:info, "Keyword created successfully.")
        |> redirect(to: Routes.keyword_path(conn, :show, keyword))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    keyword = Crawlers.get_keyword!(id)
    render(conn, "show.html", keyword: keyword)
  end

  def edit(conn, %{"id" => id}) do
    keyword = Crawlers.get_keyword!(id)
    changeset = Crawlers.change_keyword(keyword)
    render(conn, "edit.html", keyword: keyword, changeset: changeset)
  end

  def update(conn, %{"id" => id, "keyword" => keyword_params}) do
    keyword = Crawlers.get_keyword!(id)

    case Crawlers.update_keyword(keyword, keyword_params) do
      {:ok, keyword} ->
        conn
        |> put_flash(:info, "Keyword updated successfully.")
        |> redirect(to: Routes.keyword_path(conn, :show, keyword))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", keyword: keyword, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    keyword = Crawlers.get_keyword!(id)
    {:ok, _keyword} = Crawlers.delete_keyword(keyword)

    conn
    |> put_flash(:info, "Keyword deleted successfully.")
    |> redirect(to: Routes.keyword_path(conn, :index))
  end
end
