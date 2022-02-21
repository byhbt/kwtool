defmodule KwtoolWeb.Api.V1.KeywordController do
  use KwtoolWeb, :api_controller

  alias Kwtool.Crawler.Keywords

  def index(conn, %{"query" => search_phrase}) do
    keywords =
      conn
      |> Guardian.Plug.current_resource()
      |> Keywords.get_keywords_by_user(search_phrase)

    conn
    |> put_status(:ok)
    |> render("show.json", %{data: keywords})
  end
end
