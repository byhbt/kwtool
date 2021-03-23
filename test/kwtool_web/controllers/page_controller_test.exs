defmodule KwtoolWeb.PageControllerTest do
  use KwtoolWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Keyword research tool"
  end
end
