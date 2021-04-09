defmodule KwtoolWeb.SessionControllerTest do
  use KwtoolWeb.ConnCase, async: true

  alias Kwtool.Accounts.Guardian

  describe "get sign_in/2" do
    test "returns 200 status", %{conn: conn} do
      conn = get(conn, "/sign_in")

      assert html_response(conn, 200) =~ "Login"
    end

    test "redirects to the home page if already sign in", %{conn: conn} do
      created_user = insert(:user)

      conn =
        conn
        |> Plug.Test.init_test_session(%{})
        |> Guardian.Plug.sign_in(created_user)
        |> get("/sign_in")

      assert redirected_to(conn) == Routes.home_path(conn, :index)
    end
  end

  describe "post sign_in/2" do
    test "redirects to the home page when the login params is valid", %{conn: conn} do
      attrs = %{email: "john.does@example.com"}
      created_user = insert(:user, attrs)

      login_form_params = %{email: attrs.email, password: "123456"}
      conn = post(conn, Routes.session_path(conn, :create), user: login_form_params)

      assert get_session(conn, :current_user_id) == created_user.id
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
    test "redirects to the home page when after click logout", %{conn: conn} do
      created_user = insert(:user)

      Guardian.Plug.sign_in(conn, created_user)
      conn = delete(conn, Routes.session_path(conn, :delete))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) == "Logged out successfully!"
    end
  end
end
