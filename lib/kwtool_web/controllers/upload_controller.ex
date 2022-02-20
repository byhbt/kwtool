defmodule KwtoolWeb.UploadController do
  use KwtoolWeb, :controller

  alias Kwtool.Crawler.Keywords
  alias KwtoolWeb.Api.V1.UploadParams

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, params) do
    with {:ok, %{keyword_file: %Plug.Upload{} = keyword_file}} <-
           ParamsValidator.validate(params, for: UploadParams),
         {:ok, :file_is_processed} <-
           Keywords.save_keywords_list(keyword_file, conn.assigns.current_user) do
      conn
      |> put_flash(:info, "The keyword file is processed successfully!")
      |> redirect(to: Routes.upload_path(conn, :index))
    else
      {:error, :file_is_empty} ->
        conn
        |> put_flash(:error, "The keyword file is empty!")
        |> redirect(to: Routes.upload_path(conn, :index))

      {:error, :invalid_params, _changeset} ->
        conn
        |> put_flash(:error, "The keyword file is invalid!")
        |> redirect(to: Routes.upload_path(conn, :index))
    end
  end
end
