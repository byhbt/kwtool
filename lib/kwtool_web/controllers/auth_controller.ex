defmodule KwtoolWeb.AuthController do
  use KwtoolWeb, :controller

  plug :put_layout, "auth.html"

  def sign_up(conn, _params) do
    render(conn, "sign_up.html")
  end
end
