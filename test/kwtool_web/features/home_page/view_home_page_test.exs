defmodule KwtoolWeb.HomePage.ViewHomePageTest do
  use KwtoolWeb.FeatureCase, async: true

  feature "view home page", %{session: session} do
    visit(session, Routes.page_path(KwtoolWeb.Endpoint, :index))
    assert_has(session, Query.text("Keyword Research Tool"))
  end
end
