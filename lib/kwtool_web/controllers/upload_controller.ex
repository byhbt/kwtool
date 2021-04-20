defmodule KwtoolWeb.UploadController do
  use KwtoolWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"keyword_file" => %Plug.Upload{} = keyword_file}) do
    user = conn.assigns.current_user

    case Kwtool.Crawlers.import_from_file(keyword_file, user) do
      {:ok, message} ->
        conn
        |> put_flash(:info, message)
        |> redirect(to: Routes.upload_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, _reason)
        |> index(%{})
    end
  end
end
