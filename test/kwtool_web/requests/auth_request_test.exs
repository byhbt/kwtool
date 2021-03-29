defmodule KwtoolWeb.Requests.AuthRequestTest do
  use KwtoolWeb.ConnCase

  describe "/sign_up" do
    test "returns 200 status", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :sign_up))
      assert conn.status == 200
    end
  end
end
