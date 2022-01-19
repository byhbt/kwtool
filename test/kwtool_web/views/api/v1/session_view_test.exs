defmodule KwtoolWeb.Api.V1.SessionViewTest do
  use KwtoolWeb.ConnCase, async: true

  alias KwtoolWeb.Api.V1.SessionView

  test "renders create.json" do
    assert SessionView.render("create.json", %{jwt: "123", email: "john@gmail.com"}) == %{
             code: :ok,
             data: %{email: "john@gmail.com", jwt: "123"},
             message: "You are successfully logged in!"
           }
  end
end
