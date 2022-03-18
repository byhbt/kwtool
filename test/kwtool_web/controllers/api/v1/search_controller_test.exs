defmodule KwtoolWeb.Api.V1.SearchControllerTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Support.ConnHelper

  describe "get index/2" do
    test "given user has keyword, returns a list of keyword", %{conn: conn} do
      created_user = insert(:user)
      keyword = insert(:keyword, phrase: "cheap flights", status: "finished", user: created_user)
      insert(:keyword_result, keyword: keyword)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.api_search_path(conn, :index, %{"url" => "google.com"}))

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
                   "relationships" => %{
                     "keyword_results" => %{"data" => [%{"id" => _, "type" => "keyword_result"}]}
                   },
                   "type" => "keywords"
                 }
               ],
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

    test "given user does NOT have any keyword, returns an empty list", %{conn: conn} do
      created_user = insert(:user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.api_search_path(conn, :index))

      assert %{"data" => [], "included" => []} = json_response(conn, 200)
    end

    test "given unauthorized request, returns unauthorized response", %{conn: conn} do
      conn = get(conn, Routes.api_search_path(conn, :index))

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
