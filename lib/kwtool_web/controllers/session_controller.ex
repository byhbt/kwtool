defmodule KwtoolWeb.SessionController do
  use KwtoolWeb, :controller

  alias Kwtool.Account.Schemas.User
  alias Kwtool.Account.{Guardian, Users}

  plug :put_layout, "auth.html"

  def new(conn, _) do
    maybe_user = conn.assigns.current_user

    if maybe_user do
      redirect(conn, to: Routes.home_path(conn, :index))
    else
      changeset = Users.change_user(%User{})
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :create))
    end
  end

  def create(conn, %{"user" => %{"email" => email, "password" => plain_text_password}}) do
    case Users.authenticate_user(email, plain_text_password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: Routes.home_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Incorrect email or password")
        |> new(%{})
    end
  end

  def delete(conn, _) do
    conn
    |> clear_session
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Logged out successfully!")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
