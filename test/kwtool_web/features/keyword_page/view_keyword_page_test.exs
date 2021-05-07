defmodule KwtoolWeb.HomePage.ViewKeywordPageTest do
  use KwtoolWeb.FeatureCase, async: true

  feature "views the keyword listing page", %{session: session} do
    created_user_1 = insert(:user)
    keyword_of_user_1 = insert(:keyword, user: created_user_1)

    created_user_2 = insert(:user)
    custom_keyword_attrs = %{phrase: "test listing per user phrase", user: created_user_2}
    keyword_of_user_2 = insert(:keyword, custom_keyword_attrs)

    session
    |> login_as(created_user_1)
    |> visit(Routes.keyword_path(KwtoolWeb.Endpoint, :index))
    |> assert_has(Query.text("Listing Keywords"))
    |> assert_has(css(".search-box"))
    |> assert_has(Query.text(keyword_of_user_1.phrase))
    |> refute_has(Query.text(keyword_of_user_2.phrase))
  end

  feature "searches for the keyword which is existing", %{session: session} do
    created_user = insert(:user)
    custom_keyword_attrs = %{phrase: "test listing per user phrase", user: created_user}
    keyword_1 = insert(:keyword, custom_keyword_attrs)
    keyword_2 = insert(:keyword, user: created_user)

    session
    |> login_as(created_user)
    |> visit(Routes.keyword_path(KwtoolWeb.Endpoint, :index))
    |> fill_in(Query.css("#query"), with: keyword_1.phrase)
    |> click(Query.button("Search"))
    |> assert_has(Query.text(keyword_1.phrase))
    |> refute_has(Query.text(keyword_2.phrase))
  end

  feature "searches for the keyword which does NOT exist", %{session: session} do
    created_user = insert(:user)
    keyword_1 = insert(:keyword, user: created_user)
    keyword_2 = insert(:keyword, user: created_user)

    session
    |> login_as(created_user)
    |> visit(Routes.keyword_path(KwtoolWeb.Endpoint, :index))
    |> fill_in(Query.css("#query"), with: "Lorem ipsum")
    |> click(Query.button("Search"))
    |> refute_has(Query.text(keyword_1.phrase))
    |> refute_has(Query.text(keyword_2.phrase))
    |> assert_has(Query.text("No keywords found."))
  end

  feature "views the keyword details page", %{session: session} do
    created_user = insert(:user)
    keyword = insert(:keyword, user: created_user)

    session
    |> login_as(created_user)
    |> visit(Routes.keyword_path(KwtoolWeb.Endpoint, :show, keyword.id))
    |> assert_has(Query.text("Result for"))
  end

  feature "redirects to the listing keywords page when given a keyword of another user", %{
    session: session
  } do
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
