defmodule KwtoolWeb.HomeControllerTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Support.ConnHelper

  describe "get home/2" do
    test "returns the dashboard page when user logged in", %{conn: conn} do
      created_user = insert(:user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.home_path(conn, :index))

      assert html_response(conn, 200) =~ "Dashboard"
    end
  end
end
