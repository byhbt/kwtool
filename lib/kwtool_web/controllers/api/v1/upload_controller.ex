defmodule KwtoolWeb.Api.V1.UploadController do
  use KwtoolWeb, :api_controller

  alias Kwtool.Crawler.Keywords
  alias KwtoolWeb.Api.V1.UploadParams

  def create(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, validated_params} <- ParamsValidator.validate(params, for: UploadParams),
         {:ok, success_message} <- Keywords.save_keywords_list(validated_params, user) do
      conn
      |> put_status(:created)
      |> render("show.json", %{data: %{id: :os.system_time(:millisecond), message: success_message}})
    else
      {:error, :file_is_empty} ->
        {:error, :upload_error, "The keyword file is empty!"}

      {:error, :file_is_invalid} ->
        {:error, :file_is_invalid, "The keyword file is empty!"}

      error ->
        error
    end
  end
end
