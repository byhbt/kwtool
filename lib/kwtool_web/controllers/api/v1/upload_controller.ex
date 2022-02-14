defmodule KwtoolWeb.Api.V1.UploadController do
  use KwtoolWeb, :controller

  alias Kwtool.Crawler.Keywords

  def create(conn, %{"keyword_file" => %Plug.Upload{} = keyword_file}) do
    user = Guardian.Plug.current_resource(conn)

    {_, alert_message} =
      case Keywords.save_keywords_list(keyword_file, user) do
        {:ok, :file_is_processed} -> {:info, "The keyword file is processed successfully!"}
        {:error, :file_is_empty} -> {:error, "The keyword file is empty!"}
        {:error, :file_is_invalid} -> {:error, "The keyword file is invalid!"}
      end

    render(conn, "show.json", %{
      data: %{id: :os.system_time(:millisecond), message: alert_message}
    })
  end
end
