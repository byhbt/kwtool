defmodule KwtoolWeb.Api.V1.UploadControllerTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Support.ConnHelper

  describe "post create/2" do
    test "redirects to the upload page when the import processed successfully", %{conn: conn} do
      example_file = %Plug.Upload{
        content_type: "text/csv",
        path: "test/support/fixtures/3-keywords.csv"
      }

      created_user = insert(:user)
      post_params = %{:keyword_file => example_file}

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> post(Routes.api_upload_path(conn, :create), post_params)

      assert %{
               "data" => %{
                 "attributes" => %{
                   "message" => "The keyword file is processed successfully!"
                 },
                 "id" => _,
                 "relationships" => %{},
                 "type" => "keywords"
               },
               "included" => []
             } = json_response(conn, 200)
    end

    test "redirects to the upload page given an empty file", %{conn: conn} do
      example_file = %Plug.Upload{
        content_type: "text/csv",
        path: "test/support/fixtures/empty-keywords.csv"
      }

      created_user = insert(:user)
      post_params = %{:keyword_file => example_file}

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> post(Routes.api_upload_path(conn, :create), post_params)

      assert redirected_to(conn) == Routes.api_upload_path(conn, :index)
      assert get_flash(conn, :error) == "The keyword file is empty!"
    end

    test "redirects to the upload page given an invalid file", %{conn: conn} do
      example_file = %Plug.Upload{
        content_type: "text/png",
        path: "test/support/fixtures/invalid-file.png"
      }

      created_user = insert(:user)
      post_params = %{keyword_file: example_file}

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> post(Routes.api_upload_path(conn, :create), post_params)

      assert redirected_to(conn) == Routes.api_upload_path(conn, :index)
      assert get_flash(conn, :error) == "The keyword file is invalid!"
    end
  end
end
