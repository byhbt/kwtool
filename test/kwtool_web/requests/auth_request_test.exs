defmodule KwtoolWeb.Requests.AuthRequestTest do
  use KwtoolWeb.ConnCase, async: true

  describe "get /sign_up" do
    test "returns 200 status", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :show))

      assert conn.status == 200
    end
  end

  describe "get /sign_in" do
    test "returns 200 status", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :new))

      assert conn.status == 200
    end
  end

  describe "post /sign_up" do
    test "returns 200 status if registration successfully", %{conn: conn} do
      password_inputs = %{password: "123456", password_confirmation: "123456"}

      conn = post(conn, Routes.auth_path(conn, :create), user: params_for(:user, password_inputs))

      assert conn.status == 302
    end
  end
end
