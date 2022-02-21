defmodule KwtoolWeb.Api.V1.KeywordController do
  use KwtoolWeb, :api_controller

  alias Kwtool.Crawler.Keywords
  alias KwtoolWeb.Api.V1.UploadParams

  def index(conn, params) do
    {:ok, keywords} = conn
                        |> Guardian.Plug.current_resource()
                        |> Keywords.get_keywords_by_user()

    conn
    |> put_status(:ok)
    |> render("show.json", %{data: %{id: :os.system_time(:millisecond), keywords: keywords}})
  end
end
