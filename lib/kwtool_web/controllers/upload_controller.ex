defmodule KwtoolWeb.UploadController do
  use KwtoolWeb, :controller

  alias Kwtool.Crawler.Keywords
  alias KwtoolWeb.Api.V1.UploadParams

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, params) do
    with {:ok, validated_params} <- ParamsValidator.validate(params, for: UploadParams),
         {:ok, :file_is_processed} <-
           Keywords.save_keywords_list(validated_params, conn.assigns.current_user) do
      conn
      |> put_flash(:info, "The keyword file is processed successfully!")
      |> redirect(to: Routes.upload_path(conn, :index))
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
