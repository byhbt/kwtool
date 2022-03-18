defmodule KwtoolWeb.Api.V1.SearchController do
  use KwtoolWeb, :api_controller

  alias Kwtool.Crawler.KeywordResults

  def index(conn, params) do
    keywords =
      conn
      |> Guardian.Plug.current_resource()
      |> KeywordResults.search(params)

    conn
    |> put_status(:ok)
    |> render("show.json", %{data: keywords})
  end
end
