defmodule KwtoolWeb.UploadController do
  use KwtoolWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"keyword_file" => %Plug.Upload{}=keyword_file}) do
    list = Kwtool.Crawlers.import_from_file(keyword_file)
  end
end
