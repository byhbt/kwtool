defmodule KwtoolWeb.PageController do
  use KwtoolWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
