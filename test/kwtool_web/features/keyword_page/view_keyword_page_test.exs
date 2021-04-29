defmodule KwtoolWeb.HomePage.ViewKeywordPageTest do
  use KwtoolWeb.FeatureCase, async: true

  feature "views keyword listing page", %{session: session} do
    created_user = insert(:user)

    session
    |> login_as(created_user)
    |> visit(Routes.keyword_path(KwtoolWeb.Endpoint, :index))
    |> assert_has(Query.text("Listing Keywords"))
  end

  feature "views keyword details page", %{session: session} do
    created_user = insert(:user)
    keyword = insert(:keyword, user: created_user)

    session
    |> login_as(created_user)
    |> visit(Routes.keyword_path(KwtoolWeb.Endpoint, :show, keyword.id))
    |> assert_has(Query.text("Result for"))
  end
end
