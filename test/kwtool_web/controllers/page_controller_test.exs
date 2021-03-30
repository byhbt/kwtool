defmodule KwtoolWeb.PageControllerTest do
  use KwtoolWeb.ConnCase

  describe "get the home route" do
    test "returns 200 status", %{conn: conn} do
      conn = get(conn, "/sign_up")
      assert html_response(conn, 200) =~ "Registration"
    end
  end
end
