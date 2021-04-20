defmodule KwtoolWeb.UploadControllerTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Support.ConnHelper

  describe "get index/2" do
    test "returns 200 status", %{conn: conn} do
      created_user = insert(:user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.upload_path(conn, :index))

      assert html_response(conn, 200) =~ "Upload"
    end
  end
end
