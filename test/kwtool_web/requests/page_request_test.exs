defmodule KwtoolWeb.Requests.PageRequestTest do
  use KwtoolWeb.ConnCase

  describe "get the home route" do
    test "returns 200 status when access the home route", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :index))

      assert conn.status == 200
    end
  end
end
