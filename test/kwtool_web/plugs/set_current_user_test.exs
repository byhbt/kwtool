defmodule KwtoolWeb.Plugs.SetCurrentUserTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Plugs.SetCurrentUser

  describe "call/2" do
    test "retrieves user data from session when it exists", %{conn: conn} do
      created_user = insert(:user)

      conn =
        conn
        |> Plug.Conn.put_private(:guardian_default_resource, created_user)
        |> call(%{})

      assert conn.assigns.current_user.id == created_user.id
      assert conn.assigns.user_signed_in? == true
    end

    test "retrieves user data from session when it does NOT exists", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.assigns.current_user == nil
      assert conn.assigns.user_signed_in? == false
    end
  end
end
