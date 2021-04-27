defmodule KwtoolWeb.KeywordControllerTest do
  use KwtoolWeb.ConnCase

  alias Kwtool.Crawlers

  describe "get index/2" do
    test "returns the keywords page when given a logged-in user", %{conn: conn} do
      conn = get(conn, Routes.keyword_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Keywords"
    end
  end
end
