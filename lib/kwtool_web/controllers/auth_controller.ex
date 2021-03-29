defmodule KwtoolWeb.AuthController do
  use KwtoolWeb, :controller

  plug :put_layout, "auth.html"

  def new(conn, _params) do
    render(conn, "sign_in.html")
  end

  def show(conn, _params) do
    render(conn, "sign_up.html")
  end

  def create_user(conn, _params) do
    IO.puts "Create user!"
  end
end
