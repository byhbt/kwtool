defmodule KwtoolWeb.PageControllerTest do
  use KwtoolWeb.ConnCase

  describe "get the home route" do
    test "returns 200 status when access the home route", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Keyword Research Tool"
    end
  end
end
