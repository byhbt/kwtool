defmodule KwtoolWeb.HomePage.ViewRegistrationPageTest do
  use KwtoolWeb.FeatureCase, async: false

  @path Routes.auth_path(KwtoolWeb.Endpoint, :show)

  feature "views registration page", %{session: session} do
    session
    |> visit(@path)
    |> assert_has(Query.text("Registration"))
  end

  feature "signs up a new user with valid information", %{session: session} do
    session
    |> visit(@path)
    |> fill_in(Query.text_field("Email"), with: "john.does@example.com")
    |> fill_in(Query.text_field("Full name"), with: "John Does")
    |> fill_in(Query.css("#user_password"), with: "123456")
    |> fill_in(Query.css("#user_password_confirmation"), with: "123456")
    |> click(Query.button("Sign up"))
    |> assert_has(Query.text("Your account is created successfully!"))
  end

  feature "signs up a new user with invalid inputs", %{session: session} do
    session
    |> visit(@path)
    |> fill_in(Query.text_field("Email"), with: "john.does@example.com")
    |> fill_in(Query.text_field("Full name"), with: "John Does")
    |> fill_in(Query.css("#user_password"), with: "123456")
    |> fill_in(Query.css("#user_password_confirmation"), with: "654321")
    |> click(Query.button("Sign up"))
    |> assert_has(Query.text("Oops, something went wrong! Please check the errors below."))
  end
end
