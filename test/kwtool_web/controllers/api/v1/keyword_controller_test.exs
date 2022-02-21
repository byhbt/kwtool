defmodule KwtoolWeb.Api.V1.KeywordControllerTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Support.ConnHelper

  describe "get index/2" do
    test "given user has keyword, returns a list of keyword", %{conn: conn} do
      created_user = insert(:user)
      insert(:keyword, phrase: "cheap flights", status: "finished", user: created_user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.api_keyword_path(conn, :index))

      assert %{
               "data" => [
                 %{
                   "attributes" => %{
                     "id" => _,
                     "inserted_at" => _,
                     "phrase" => "cheap flights",
                     "status" => "finished",
                     "updated_at" => _
                   },
                   "id" => _,
                   "relationships" => %{},
                   "type" => "keywords"
                 }
               ],
               "included" => []
             } = json_response(conn, 200)
    end

    test "given user does NOT have any keyword, returns an empty list", %{conn: conn} do
      created_user = insert(:user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.api_keyword_path(conn, :index))

      assert %{"data" => [], "included" => []} = json_response(conn, 200)
    end

    test "given unauthorized request, returns unauthorized response", %{conn: conn} do
      conn = get(conn, Routes.api_keyword_path(conn, :index))

      assert %{
               "errors" => [
                 %{
                   "code" => "unauthorized",
                   "detail" => %{},
                   "message" => "Unauthorized"
                 }
               ]
             } = json_response(conn, 401)
    end
  end
end
