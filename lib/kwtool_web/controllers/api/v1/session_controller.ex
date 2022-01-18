defmodule KwtoolWeb.Api.V1.SessionController do
  use KwtoolWeb, :controller

  alias Kwtool.Account.{Guardian, Users}
  alias KwtoolWeb.Api.V1.ErrorView

  def create(conn, %{"email" => email, "password" => password}) do
    case Users.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, %{})

        conn
        |> render("create.json", jwt: jwt, email: user.email)

      {:error, :invalid_credentials} ->
        conn
        |> put_status(401)
        |> put_view(ErrorView)
        |> render("error.json", message: "User could not be authenticated")
    end
  end
end
