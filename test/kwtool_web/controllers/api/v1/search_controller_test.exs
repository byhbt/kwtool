defmodule KwtoolWeb.Api.V1.SearchControllerTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Support.ConnHelper

  describe "get index/2" do
    test "given search with keyword param, returns a list of matching keywords", %{
      conn: conn
    } do
      created_user = insert(:user)
      keyword = insert(:keyword, phrase: "cheap flights", status: "finished", user: created_user)
      insert(:keyword_result, keyword: keyword)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.api_search_path(conn, :index, %{"keyword" => "cheap flights"}))

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
                     "organic_result_urls" => ["https://company-a.com", "https://company-b.com"],
                     "top_ads_count" => 2,
                     "top_ads_urls" => ["https://ads-product-a.com", "https://ads-product-b.com"]
                   },
                   "id" => _,
                   "relationships" => %{},
                   "type" => "keyword_result"
                 }
               ]
             } = json_response(conn, 200)
    end

    test "given search with keyword, url, and min ads count params, returns keywords that matching given filters",
         %{conn: conn} do
      created_user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: created_user)
      insert(:keyword_result, keyword: keyword, all_ads_count: 12)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(
          Routes.api_search_path(conn, :index, %{
            "keyword" => "coffee",
            "url" => "company-a.com",
            "min_ads" => 10
          })
        )

      assert %{
               "data" => [
                 %{
                   "attributes" => %{
                     "inserted_at" => _,
                     "phrase" => "coffee",
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
                     "all_ads_count" => 12,
                     "all_links_count" => 2,
                     "organic_result_count" => 2,
                     "organic_result_urls" => ["https://company-a.com", "https://company-b.com"],
                     "top_ads_count" => 2,
                     "top_ads_urls" => ["https://ads-product-a.com", "https://ads-product-b.com"]
                   },
                   "id" => _,
                   "relationships" => %{},
                   "type" => "keyword_result"
                 }
               ]
             } = json_response(conn, 200)
    end

    test "given search with keyword has multiple crawl results by url params, returns keyword and results that matching given filters",
         %{conn: conn} do
      created_user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: created_user)
      insert(:keyword_result, keyword: keyword, organic_result_urls: ["https://star-coffee.com"])
      insert(:keyword_result, keyword: keyword, organic_result_urls: ["https://milano-coffee.com"])

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(
          Routes.api_search_path(conn, :index, %{
            "keyword" => "coffee",
            "url" => "coffee"
          })
        )

      assert %{
               "data" => [
                 %{
                   "attributes" => %{
                     "inserted_at" => _,
                     "phrase" => "coffee",
                     "status" => "finished",
                     "updated_at" => _
                   },
                   "id" => _,
                   "relationships" => %{
                     "keyword_results" => %{
                       "data" => [
                         %{"id" => _, "type" => "keyword_result"},
                         %{"id" => _, "type" => "keyword_result"}
                       ]
                     }
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
                     "organic_result_urls" => ["https://star-coffee.com"],
                     "top_ads_count" => 2,
                     "top_ads_urls" => ["https://ads-product-a.com", "https://ads-product-b.com"]
                   },
                   "id" => _,
                   "relationships" => %{},
                   "type" => "keyword_result"
                 },
                 %{
                   "attributes" => %{
                     "all_ads_count" => 2,
                     "all_links_count" => 2,
                     "organic_result_count" => 2,
                     "organic_result_urls" => ["https://milano-coffee.com"],
                     "top_ads_count" => 2,
                     "top_ads_urls" => ["https://ads-product-a.com", "https://ads-product-b.com"]
                   },
                   "id" => _,
                   "relationships" => %{},
                   "type" => "keyword_result"
                 }
               ]
             } = json_response(conn, 200)
    end

    test "given search with keyword does not exist, returns an empty result",
         %{conn: conn} do
      created_user = insert(:user)
      keyword = insert(:keyword, phrase: "coffee", status: "finished", user: created_user)
      insert(:keyword_result, keyword: keyword, all_ads_count: 12)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.api_search_path(conn, :index, %{"keyword" => "something else"}))

      assert json_response(conn, 200) == %{"data" => [], "included" => []}
    end

    test "given missing keyword in search params, returns an error", %{conn: conn} do
      created_user = insert(:user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.api_search_path(conn, :index))

      assert %{
               "errors" => [
                 %{
                   "code" => "validation_error",
                   "detail" => %{"keyword" => ["can't be blank"]},
                   "message" => "Keyword can't be blank"
                 }
               ]
             } = json_response(conn, 422)
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
