defmodule KwtoolWeb.Api.V1.UploadControllerTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Support.ConnHelper

  describe "post create/2" do
    test "given the import processed successfully, returns 201 status with success message", %{
      conn: conn
    } do
      created_user = insert(:user)
      post_params = %{:keyword_file => fixture_file_upload("3-keywords.csv")}

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> post(Routes.api_upload_path(conn, :create), post_params)

      assert %{
               "data" => %{
                 "attributes" => %{
                   "message" => "Keyword file is processed successfully"
                 },
                 "id" => _,
                 "relationships" => %{},
                 "type" => "keywords"
               },
               "included" => []
             } = json_response(conn, 201)
    end

    test "given an empty file, returns 422 status with error", %{conn: conn} do
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

    test "given an invalid file, returns 422 status with error", %{conn: conn} do
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

    test "given unauthenticated upload request, returns 401 status with error", %{conn: conn} do
      post_params = %{:keyword_file => fixture_file_upload("3-keywords.csv")}
      conn = post(conn, Routes.api_upload_path(conn, :create), post_params)

      assert %{
               "errors" => [
                 %{"code" => "unauthorized", "detail" => %{}, "message" => "Unauthorized"}
               ]
             } = json_response(conn, 401)
    end
  end
end
