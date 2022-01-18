defmodule KwtoolWeb.Api.V1.SessionView do
  use KwtoolWeb, :view

  def render("create.json", %{jwt: jwt, email: email}) do
    %{
      status: :ok,
      data: %{
        email: email,
        jwt: jwt
      },
      message: "You are successfully logged in! Add this token to authorization header to make authorized requests."
    }
  end

  def render("error.json", %{message: message}) do
    %{
      status: :not_found,
      data: %{},
      message: message
    }
  end
end
