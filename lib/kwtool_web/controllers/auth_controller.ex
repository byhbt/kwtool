defmodule KwtoolWeb.AuthController do
  use KwtoolWeb, :controller

  alias Kwtool.Accounts
  alias Kwtool.Accounts.User

  plug :put_layout, "auth.html"

  def new(conn, _params) do
    render(conn, "sign_in.html")
  end

  def show(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "sign_up.html", changeset: changeset)
  end

  def create_user(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
