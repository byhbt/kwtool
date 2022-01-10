defmodule KwtoolWeb.UploadControllerTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Support.ConnHelper

  describe "get index/2" do
    test "returns 200 status when accessing with a logged-in user", %{conn: conn} do
      created_user = insert(:user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.upload_path(conn, :index))

      assert html_response(conn, 200) =~ "Upload"
    end
  end

  describe "post create/2" do
    test "redirects to the upload page when the import processed successfully", %{conn: conn} do
      example_file = %Plug.Upload{
        content_type: "text/csv",
        path: "test/support/fixtures/keywords.csv"
      }

      created_user = insert(:user)
      post_params = %{:keyword_file => example_file}

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> post(Routes.upload_path(conn, :create), post_params)

      assert redirected_to(conn) == Routes.upload_path(conn, :index)
      assert get_flash(conn, :info) == "The keyword file is processed successfully!"
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
        |> post(Routes.upload_path(conn, :create), post_params)

      assert redirected_to(conn) == Routes.upload_path(conn, :index)
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
        |> post(Routes.upload_path(conn, :create), post_params)

      assert redirected_to(conn) == Routes.upload_path(conn, :index)
      assert get_flash(conn, :error) == "The keyword file is invalid!"
    end
  end
end
