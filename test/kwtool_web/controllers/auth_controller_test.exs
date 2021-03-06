defmodule KwtoolWeb.AuthControllerTest do
  use KwtoolWeb.ConnCase, async: true

  describe "get show/2" do
    test "returns 200 status when accessing the registration page", %{conn: conn} do
      conn = get(conn, "/sign_up")

      assert html_response(conn, 200) =~ "Registration"
    end
  end

  describe "post create/2" do
    test "redirects to the home page when given a valid registration params", %{conn: conn} do
      password_inputs = %{password: "123456", password_confirmation: "123456"}

      conn = post(conn, Routes.auth_path(conn, :create), user: params_for(:user, password_inputs))

      assert redirected_to(conn) == Routes.home_path(conn, :index)
      assert get_flash(conn, :info) == "Your account is created successfully!"
    end

    test "renders errors when given invalid registration params", %{conn: conn} do
      override_email_attr = %{email: "invalid_email"}

      conn =
        post(conn, Routes.auth_path(conn, :create), user: params_for(:user, override_email_attr))

      assert html_response(conn, 200) =~
               "Oops, something went wrong! Please check the errors below."
    end
  end
end
