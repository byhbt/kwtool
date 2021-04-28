defmodule KwtoolWeb.HomePage.ViewKeywordPageTest do
  use KwtoolWeb.FeatureCase, async: true

  feature "views keyword listing page", %{session: session} do
    created_user = insert(:user)

    session
    |> login_as(created_user)
    |> visit(Routes.keyword_path(KwtoolWeb.Endpoint, :index))
    |> assert_has(Query.text("Listing Keywords"))
  end
end
