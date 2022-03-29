defmodule KwtoolWeb.Api.V1.SearchController do
  use KwtoolWeb, :api_controller

  alias Kwtool.Crawler.KeywordResults
  alias KwtoolWeb.Api.V1.SearchParams

  def index(conn, params) do
    with {:ok, validated_params} <- ParamsValidator.validate(params, for: SearchParams),
         keywords <- KeywordResults.search(Guardian.Plug.current_resource(conn), validated_params) do
      conn
      |> put_status(:ok)
      |> render("show.json", %{data: keywords})
    end
  end
end
