defmodule KwtoolWeb.UploadController do
  use KwtoolWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create do
  end
end
