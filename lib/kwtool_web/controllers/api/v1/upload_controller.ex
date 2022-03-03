defmodule KwtoolWeb.Api.V1.UploadController do
  use KwtoolWeb, :api_controller

  alias Kwtool.Crawler.Keywords
  alias KwtoolWeb.Api.V1.UploadParams

  def create(conn, params) do
    with {:ok, %{keyword_file: %Plug.Upload{} = keyword_file}} <-
           ParamsValidator.validate(params, for: UploadParams),
         {:ok, _message} <- Keywords.save_keywords_list(keyword_file, conn.assigns.current_user) do
      conn
      |> put_status(:created)
      |> render("show.json", %{
        data: %{
          id: :os.system_time(:millisecond),
          message: "Keyword file is processed successfully"
        }
      })
    end
  end
end
