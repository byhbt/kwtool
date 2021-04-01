defmodule KwtoolWeb.AuthController do
  use KwtoolWeb, :controller

  plug :put_layout, "auth.html"

  def index(conn, _params) do
    render(conn, "sign_in.html")
  end

  def show(conn, _params) do
    render(conn, "sign_up.html")
  end
end
