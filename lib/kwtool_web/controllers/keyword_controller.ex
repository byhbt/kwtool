defmodule KwtoolWeb.KeywordController do
  use KwtoolWeb, :controller

  alias Kwtool.Crawlers

  def index(conn, params) do
    {keywords, pagination} = Crawlers.get_user_keywords(conn.assigns.current_user, params)

    render(conn, "index.html", keywords: keywords, pagination: pagination)
  end

  def show(conn, %{"id" => id}) do
    case Crawlers.get_keyword(conn.assigns.current_user, id) do
      nil ->
        conn
        |> put_flash(:error, "Keyword not found.")
        |> redirect(to: Routes.keyword_path(conn, :index))

      keyword ->
        render(conn, "show.html", keyword: keyword)
    end
  end
end
