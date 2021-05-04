defmodule KwtoolWeb.KeywordController do
  use KwtoolWeb, :controller

  alias Kwtool.Crawlers

  def index(conn, params) do
    {keywords, pagination} = Crawlers.get_user_keywords(conn.assigns.current_user, params)

    render(conn, "index.html", keywords: keywords, pagination: pagination)
  end

  def show(conn, %{"id" => id}) do
    keyword = Crawlers.get_keyword!(id)

    render(conn, "show.html", keyword: keyword)
  end
end
