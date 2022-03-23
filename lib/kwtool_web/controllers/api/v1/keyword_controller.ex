defmodule KwtoolWeb.Api.V1.KeywordController do
  use KwtoolWeb, :api_controller

  alias Kwtool.Crawler.Keywords

  def index(conn, _params) do
    keywords =
      conn
      |> Guardian.Plug.current_resource()
      |> Keywords.get_keywords_by_user()

    conn
    |> put_status(:ok)
    |> render("show.json", %{data: keywords})
  end

  def show(conn, %{"id" => keyword_id} = _params) do
    keyword =
      conn
      |> Guardian.Plug.current_resource()
      |> Keywords.find_keyword_by_user(keyword_id)

    case keyword do
      nil ->
        {:error, :not_found, "Keyword"}

      keyword ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{data: keyword})
    end
  end
end
