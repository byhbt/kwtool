defmodule KwtoolWeb.Api.V1.UploadControllerTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Support.ConnHelper

  describe "post create/2" do
    test "redirects to the upload page when the import processed successfully", %{conn: conn} do
      created_user = insert(:user)
      post_params = %{:keyword_file => fixture_file_upload("3-keywords.csv")}

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> post(Routes.api_upload_path(conn, :create), post_params)

      assert %{
               "data" => %{
                 "attributes" => %{
                   "message" => "file_is_processed"
                 },
                 "id" => _,
                 "relationships" => %{},
                 "type" => "keywords"
               },
               "included" => []
             } = json_response(conn, 201)
    end

    test "redirects to the upload page given an empty file", %{conn: conn} do
      created_user = insert(:user)
      post_params = %{:keyword_file => fixture_file_upload("empty-file.csv")}

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> post(Routes.api_upload_path(conn, :create), post_params)

      assert %{
               "errors" => [
                 %{
                   "code" => "validation_error",
                   "detail" => %{"keyword_file" => ["has no content"]},
                   "message" => "Keyword file has no content"
                 }
               ]
             } = json_response(conn, 422)
    end

    test "redirects to the upload page given an invalid file", %{conn: conn} do
      created_user = insert(:user)
      post_params = %{keyword_file: fixture_file_upload("invalid-file.png")}

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> post(Routes.api_upload_path(conn, :create), post_params)

      assert %{
               "errors" => [
                 %{
                   "code" => "validation_error",
                   "detail" => %{"keyword_file" => ["is not in supported mime types (text/csv)"]},
                   "message" => "Keyword file is not in supported mime types (text/csv)"
                 }
               ]
             } = json_response(conn, 422)
    end
  end
end
