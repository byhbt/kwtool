defmodule KwtoolWeb.KeywordController do
  use KwtoolWeb, :controller

  alias Kwtool.Crawlers

  def index(conn, _params) do
    keywords = Crawlers.list_keywords()

    render(conn, "index.html", keywords: keywords)
  end

  def show(conn, %{"id" => id}) do
    keyword = Crawlers.get_keyword!(id)

    render(conn, "show.html", keyword: keyword)
  end
end
