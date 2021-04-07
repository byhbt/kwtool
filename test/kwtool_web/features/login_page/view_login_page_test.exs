defmodule KwtoolWeb.HomePage.ViewLoginPageTest do
  use KwtoolWeb.FeatureCase, async: true

  @path Routes.session_path(KwtoolWeb.Endpoint, :new)

  feature "views login page", %{session: session} do
    visit(session, @path)

    assert_has(session, Query.text("Login"))
  end

  feature "signs in user with valid information", %{session: session} do
    attrs = %{email: "john.does@example.com"}
    insert(:user, attrs)

    session
    |> visit(@path)
    |> fill_in(Query.text_field("Email"), with: "john.does@example.com")
    |> fill_in(Query.css("#user_password"), with: "123456")
    |> click(Wallaby.Query.button("Sign in"))
    |> assert_has(Query.text("Welcome back!"))
  end
end
