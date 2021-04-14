defmodule KwtoolWeb.UploadControllerTest do
  use KwtoolWeb.ConnCase, async: true
  alias Kwtool.Accounts.Guardian

  describe "get index/2" do
    test "returns 200 status", %{conn: conn} do
      created_user = insert(:user)

      conn =
        conn
        |> Guardian.Plug.sign_in(created_user)
        |> get("/upload")

      assert html_response(conn, 200) =~ "Upload"
    end
  end
end
