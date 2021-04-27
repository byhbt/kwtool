defmodule KwtoolWeb.SessionControllerTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Support.ConnHelper

  describe "get sign_in/2" do
    test "returns 200 status", %{conn: conn} do
      conn = get(conn, "/sign_in")

      assert html_response(conn, 200) =~ "Login"
    end

    test "redirects to the home page if already sign in", %{conn: conn} do
      created_user = insert(:user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get("/sign_in")

      assert redirected_to(conn) == Routes.home_path(conn, :index)
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

      assert get_flash(conn, :error) == "Incorrect email or password"
      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "get sign_out/2" do
    test "redirects to the home page when the user clicks the logout button", %{conn: conn} do
      created_user = insert(:user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> delete(Routes.session_path(conn, :delete))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) == "Logged out successfully!"
    end
  end
end
