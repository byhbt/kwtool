defmodule KwtoolWeb.KeywordControllerTest do
  use KwtoolWeb.ConnCase

  describe "get index/2" do
    test "returns the keywords page when given a logged-in user", %{conn: conn} do
      created_user = insert(:user)
      keyword = insert(:keyword, user: created_user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.keyword_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Keywords"
      assert html_response(conn, 200) =~ keyword.phrase
    end

    test "returns the searching keywords when given a query param", %{conn: conn} do
      created_user = insert(:user)
      keyword1 = insert(:keyword, user: created_user)

      search_params = %{
        query: keyword1.phrase
      }

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.keyword_path(conn, :index, search_params))

      assert html_response(conn, 200) =~ "Listing Keywords"
      assert html_response(conn, 200) =~ keyword1.phrase
    end
  end

  describe "get show/2" do
    test "returns the details of a keyword page when given a keyword belongs to the logged-in user",
         %{conn: conn} do
      created_user = insert(:user)
      keyword = insert(:keyword, user: created_user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.keyword_path(conn, :show, keyword.id))

      assert html_response(conn, 200) =~ "Result for \"#{keyword.phrase}\""
    end

    test "redirects to the keywords listing page when given a keyword does NOT belong to the logged-in user",
         %{conn: conn} do
      created_user_1 = insert(:user)

      created_user_2 = insert(:user)
      keyword_of_user_2 = insert(:keyword, user: created_user_2)

      conn =
        conn
        |> with_signed_in_user(created_user_1)
        |> get(Routes.keyword_path(conn, :show, keyword_of_user_2.id))

      assert get_flash(conn, :error) == "Keyword not found."
      assert redirected_to(conn) == Routes.keyword_path(conn, :index)
    end
  end
end
