defmodule KwtoolWeb.SessionControllerTest do
  use KwtoolWeb.ConnCase, async: true

  describe "get sign_in/2" do
    test "returns 200 status", %{conn: conn} do
      conn = KwtoolWeb.SessionController.call(conn, :new)

      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "post sign_in/2" do
    test "redirects to the home page when the login params is valid", %{conn: conn} do
      attrs = %{email: "john.does@example.com"}
      insert(:user, attrs)

      login_form_params = %{email: attrs.email, password: "123456"}
      conn = post(conn, Routes.session_path(conn, :create), user: login_form_params)

      assert redirected_to(conn) == Routes.home_path(conn, :index)
      assert get_flash(conn, :info) == "Welcome back!"
    end

    test "renders the login page when the login params is NOT valid", %{conn: conn} do
      attrs = %{email: "john.does@example.com"}
      insert(:user, attrs)

      login_form_params = %{email: "someone.else@example.com", password: "123456"}
      conn = post(conn, Routes.session_path(conn, :create), user: login_form_params)

      assert html_response(conn, 200) =~ "Login"
      assert get_flash(conn, :error) == "Incorrect email or password"
    end
  end
end
