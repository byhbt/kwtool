defmodule KwtoolWeb.UploadController do
  use KwtoolWeb, :controller

  alias Kwtool.Crawlers

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"keyword_file" => %Plug.Upload{} = keyword_file}) do
    case Crawlers.save_keywords_list(keyword_file, conn.assigns.current_user) do
      {:ok, message} ->
        conn
        |> put_flash(:info, message)
        |> redirect(to: Routes.upload_path(conn, :index))
    end
  end
end
