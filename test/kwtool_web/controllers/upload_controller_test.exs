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

  describe "post create/2" do
    test "redirects back to the upload page when the import is success", %{conn: conn} do
      upload_file = %Plug.Upload{path: "test/fixture/keywords.csv", filename: "keywords.csv"}
      created_user = insert(:user)
      post_params = %{ :keyword_file => upload_file }

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> post(Routes.upload_path(conn, :create), post_params)

      assert redirected_to(conn) == Routes.upload_path(conn, :index)
      assert get_flash(conn, :info) == "The keyword file is processed successfully!"
    end
  end
end
