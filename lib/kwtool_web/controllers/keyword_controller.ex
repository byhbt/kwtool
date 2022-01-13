defmodule KwtoolWeb.KeywordController do
  use KwtoolWeb, :controller

  alias Kwtool.Crawler.Keywords

  def index(conn, params) do
    {keywords, pagination} = Keywords.paginate_user_keywords(conn.assigns.current_user, params)

    render(conn, "index.html", keywords: keywords, pagination: pagination)
  end

  def show(conn, %{"id" => keyword_id}) do
    case Keywords.get_keyword_by_user(conn.assigns.current_user, keyword_id) do
      nil ->
        conn
        |> put_flash(:error, "Keyword not found.")
        |> redirect(to: Routes.keyword_path(conn, :index))

      keyword ->
        render(conn, "show.html", keyword: keyword)
    end
  end
end
