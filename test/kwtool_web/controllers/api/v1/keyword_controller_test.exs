defmodule KwtoolWeb.Api.V1.KeywordControllerTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Support.ConnHelper

  describe "post create/2" do
    test "returns the list of keywords of the given user", %{conn: conn} do
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

    test "returns an empty list given user does NOT has any keyword", %{conn: conn} do
      created_user = insert(:user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.api_keyword_path(conn, :index))

      assert %{"data" => [], "included" => []} = json_response(conn, 200)
    end

    test "returns unauthorized ", %{conn: conn} do
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
