defmodule KwtoolWeb.Api.V1.SessionView do
  use JSONAPI.View, type: "logins"

  # def render("create.json", %{jwt: jwt, email: email}) do
  #   %{
  #     code: :ok,
  #     data: %{
  #       email: email,
  #       jwt: jwt
  #     },
  #     message: "You are successfully logged in!"
  #   }
  # end

  def fields do
    [
      :jwt,
      :email
    ]
  end
end
