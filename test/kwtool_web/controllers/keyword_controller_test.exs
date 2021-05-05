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
  end

  describe "get show/2" do
    test "returns the details of a keyword page when given a logged-in user", %{conn: conn} do
      created_user = insert(:user)
      keyword = insert(:keyword, user: created_user)

      conn =
        conn
        |> with_signed_in_user(created_user)
        |> get(Routes.keyword_path(conn, :show, keyword.id))

      assert html_response(conn, 200) =~ "Result for \"#{keyword.phrase}\""
    end

    test "returns to the list page when given a keyword not belong to the owner", %{conn: conn} do
      created_user_1 = insert(:user)

      created_user_2 = insert(:user)
      user_2_keyword = insert(:keyword, user: created_user_2)

      conn =
        conn
        |> with_signed_in_user(created_user_1)
        |> get(Routes.keyword_path(conn, :show, user_2_keyword.id))

      assert redirected_to(conn) == Routes.keyword_path(conn, :index)
    end
  end
end
