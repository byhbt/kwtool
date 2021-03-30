defmodule KwtoolWeb.Requests.PageRequestTest do
  use KwtoolWeb.ConnCase, async: true

  describe "get /" do
    test "returns 200 status", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :index))
      assert conn.status == 200
    end
  end
end
