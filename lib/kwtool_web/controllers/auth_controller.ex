defmodule KwtoolWeb.AuthController do
  use KwtoolWeb, :controller

  alias Kwtool.Accounts
  alias Kwtool.Accounts.Schemas.User

  plug :put_layout, "auth.html"

  def new(conn, _params) do
    changeset = User.registration_changeset(%{})

    render(conn, "sign_in.html", changeset: changeset)
  end

  def show(conn, _params) do
    changeset = User.registration_changeset(%{})

    render(conn, "sign_up.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Your account is created successfully!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "sign_up.html", changeset: changeset)
    end
  end
end
