defmodule KwtoolWeb.UploadController do
  use KwtoolWeb, :controller

  alias NimbleCSV.RFC4180, as: CSV

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"keyword_file" => %Plug.Upload{}=keyword_file}) do
    list =
    keyword_file.path
    |> File.stream!
    |> CSV.parse_stream(skip_headers: false)
    |> Enum.each(&IO.puts/1)
  end
end
