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

  describe "get show/2" do
    test "given keyword with crawl result, returns crawl result in the relationship and includes fields",
         %{
           conn: conn
         } do
      created_user = insert(:user)
      keyword = insert(:keyword, phrase: "cheap flights", status: "added", user: created_user)
      insert(:keyword_result, keyword: keyword)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.api_keyword_path(conn, :show, keyword.id))

      assert %{
               "data" => %{
                 "attributes" => %{
                   "inserted_at" => _,
                   "phrase" => "cheap flights",
                   "status" => "added",
                   "updated_at" => _
                 },
                 "id" => _,
                 "relationships" => %{
                   "keyword_results" => %{"data" => [%{"id" => _, "type" => "keyword_result"}]}
                 },
                 "type" => "keywords"
               },
               "included" => [
                 %{
                   "attributes" => %{
                     "all_ads_count" => 2,
                     "all_links_count" => 2,
                     "organic_result_count" => 2,
                     "organic_result_urls" => ["https://google.com", "https://example.com"],
                     "top_ads_count" => 2,
                     "top_ads_urls" => ["https://google.com", "https://example.com"]
                   },
                   "id" => _,
                   "relationships" => %{},
                   "type" => "keyword_result"
                 }
               ]
             } = json_response(conn, 200)
    end

    test "given keyword does NOT has any result, returns an empty relationship and includes fields",
         %{
           conn: conn
         } do
      created_user = insert(:user)
      keyword = insert(:keyword, phrase: "cheap flights", status: "added", user: created_user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.api_keyword_path(conn, :show, keyword.id))

      assert %{
               "data" => %{
                 "attributes" => %{
                   "inserted_at" => _,
                   "phrase" => "cheap flights",
                   "status" => "added",
                   "updated_at" => _
                 },
                 "id" => _,
                 "relationships" => %{"keyword_results" => %{"data" => []}},
                 "type" => "keywords"
               },
               "included" => []
             } = json_response(conn, 200)
    end

    test "given keyword does NOT exist, returns 404 error", %{
      conn: conn
    } do
      created_user = insert(:user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.api_keyword_path(conn, :show, 999))

      assert %{
               "errors" => [
                 %{
                   "code" => "not_found",
                   "detail" => %{},
                   "message" => "Keyword cannot be found."
                 }
               ]
             } = json_response(conn, 404)
    end

    test "given unauthorized request, returns unauthorized response", %{conn: conn} do
      conn = get(conn, Routes.api_keyword_path(conn, :show, 10))

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
