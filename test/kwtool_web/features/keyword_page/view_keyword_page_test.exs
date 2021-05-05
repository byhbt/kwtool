defmodule KwtoolWeb.HomePage.ViewKeywordPageTest do
  use KwtoolWeb.FeatureCase, async: true

  feature "views keyword listing page", %{session: session} do
    created_user_1 = insert(:user)
    keyword_of_user_1 = insert(:keyword, user: created_user_1)

    created_user_2 = insert(:user)
    keyword_of_user_2 = insert(:keyword, user: created_user_2)

    session
    |> login_as(created_user_1)
    |> visit(Routes.keyword_path(KwtoolWeb.Endpoint, :index))
    |> assert_has(Query.text("Listing Keywords"))
    |> assert_has(Query.text(keyword_of_user_1.phrase))
    |> refute_has(Query.text(keyword_of_user_2.phrase))
  end

  feature "views keyword details page", %{session: session} do
    created_user = insert(:user)
    keyword = insert(:keyword, user: created_user)

    session
    |> login_as(created_user)
    |> visit(Routes.keyword_path(KwtoolWeb.Endpoint, :show, keyword.id))
    |> assert_has(Query.text("Result for"))
  end

  feature "redirects to listing keywords page when given other user keyword", %{session: session} do
    created_user_1 = insert(:user)
    keyword_of_user_1 = insert(:keyword, user: created_user_1)

    created_user_2 = insert(:user)
    keyword_of_user_2 = insert(:keyword, user: created_user_2)

    session
    |> login_as(created_user_1)
    |> visit(Routes.keyword_path(KwtoolWeb.Endpoint, :show, keyword_of_user_2.id))
    |> assert_has(Query.text(keyword_of_user_1.phrase))
    |> assert_has(Query.text("Listing Keywords"))
  end
end
