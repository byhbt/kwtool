defmodule KwtoolWeb.HomePage.ViewHomePageTest do
  use KwtoolWeb.FeatureCase

  feature "view home page", %{session: session} do
    visit(session, Routes.page_path(KwtoolWeb.Endpoint, :index))

    assert_has(session, Query.text("Keyword research tool"))
  end
end
