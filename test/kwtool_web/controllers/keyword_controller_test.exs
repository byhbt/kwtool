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
  end
end
