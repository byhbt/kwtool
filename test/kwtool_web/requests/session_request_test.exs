defmodule KwtoolWeb.Requests.SessionRequestTest do
  use KwtoolWeb.ConnCase, async: true

  describe "get /sign_in" do
    test "returns 200 status", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))

      assert conn.status == 200
    end
  end
end
