defmodule KwtoolWeb.HomePage.ViewLoginPageTest do
  use KwtoolWeb.FeatureCase, async: true

  @path Routes.auth_path(KwtoolWeb.Endpoint, :index)

  feature "views login page", %{session: session} do
    visit(session, @path)
    assert_has(session, Query.text("Login"))
  end
end
