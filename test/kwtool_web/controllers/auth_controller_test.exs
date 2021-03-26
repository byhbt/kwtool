defmodule KwtoolWeb.AuthControllerTest do
  use KwtoolWeb.ConnCase

  describe "get the sign up route" do
    test "returns 200 status", %{conn: conn} do
      conn = get(conn, "/sign_up")
      assert html_response(conn, 200) =~ "Keyword Research Tool"
    end
  end
end
