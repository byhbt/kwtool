defmodule KwtoolWeb.UploadController do
  use KwtoolWeb, :controller

  alias Kwtool.Crawlers

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"keyword_file" => %Plug.Upload{} = keyword_file}) do
    {alert_type, alert_message} =
      case Crawlers.save_keywords_list(keyword_file, conn.assigns.current_user) do
        {:ok, :file_is_proccessed} -> {:info, "The keyword file is processed successfully!"}
        {:error, :file_is_empty} -> {:error, "The keyword file is empty!"}
        {:error, :file_is_invalid} -> {:error, "The keyword file is invalid!"}
      end

    conn
    |> put_flash(alert_type, alert_message)
    |> redirect(to: Routes.upload_path(conn, :index))
  end
end
