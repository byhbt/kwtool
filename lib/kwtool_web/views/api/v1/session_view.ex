defmodule KwtoolWeb.Api.V1.SessionView do
  use KwtoolWeb, :view

  def render("create.json", %{jwt: jwt, email: email}) do
    %{
      code: :ok,
      data: %{
        email: email,
        jwt: jwt
      },
      message: "You are successfully logged in!"
    }
  end
end
