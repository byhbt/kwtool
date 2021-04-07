defmodule KwtoolWeb.SessionController do
  use KwtoolWeb, :controller

  alias Kwtool.{Accounts, Accounts.Guardian, Accounts.Schemas.User}

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/dashboard")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :sign_in))
    end
  end

  def sign_in(conn, %{"user" => %{"email" => email, "password" => plain_text_password}}) do
    Accounts.authenticate_user(email, plain_text_password)
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
    |> redirect(to: "/dashboard")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
