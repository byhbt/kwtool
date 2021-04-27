defmodule KwtoolWeb.PageControllerTest do
  use KwtoolWeb.ConnCase, async: true

  describe "get index/2" do
    test "returns 200 status when accessing the home page", %{conn: conn} do
      conn = get(conn, "/")

      assert html_response(conn, 200) =~ "Keyword Research Tool"
    end
  end
end
