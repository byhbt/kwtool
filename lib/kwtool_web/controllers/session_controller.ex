defmodule KwtoolWeb.SessionController do
  use KwtoolWeb, :controller

  alias Kwtool.Accounts
  alias Kwtool.Accounts.Guardian
  alias Kwtool.Accounts.Schemas.User

  plug :put_layout, "auth.html"

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/home")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :create))
    end
  end

  def create(conn, %{"user" => %{"email" => email, "password" => plain_text_password}}) do
    email
    |> Accounts.authenticate_user(plain_text_password)
    |> login_reply(conn)
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/home")
  end

  defp login_reply({:error, _reason}, conn) do
    conn
    |> put_flash(:error, "Incorrect email or password")
    |> new(%{})
  end
end
