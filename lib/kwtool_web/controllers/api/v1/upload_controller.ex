defmodule KwtoolWeb.Api.V1.UploadController do
  use KwtoolWeb, :api_controller

  alias Kwtool.Crawler.Keywords
  alias KwtoolWeb.Api.V1.UploadParams

  def create(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %{keyword_file: %Plug.Upload{} = keyword_file}} <-
           ParamsValidator.validate(params, for: UploadParams),
         {:ok, success_message} <- Keywords.save_keywords_list(keyword_file, user) do
      conn
      |> put_status(:created)
      |> render("show.json", %{data: %{id: :os.system_time(:millisecond), message: success_message}})
    end
  end
end
