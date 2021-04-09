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
    case Accounts.authenticate_user(email, plain_text_password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:current_user_id, user.id)
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/home")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Incorrect email or password")
        |> new(%{})
    end
  end

  def delete(conn, _) do
    conn
    |> clear_session
    |> put_flash(:info, "Logged out successfully!")
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/")
  end
end
