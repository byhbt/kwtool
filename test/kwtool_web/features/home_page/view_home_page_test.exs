defmodule KwtoolWeb.HomePage.ViewHomePageTest do
  use KwtoolWeb.FeatureCase, async: true

  feature "view home page", %{session: session} do
    session
    |> visit(Routes.page_path(KwtoolWeb.Endpoint, :index))
    |> assert_has(Query.text("Keyword Research Tool"))
  end
end
