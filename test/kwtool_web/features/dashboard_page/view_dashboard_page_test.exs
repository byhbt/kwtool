defmodule KwtoolWeb.HomePage.ViewDashboardPageTest do
  use KwtoolWeb.FeatureCase, async: true

  import Wallaby.Query, only: [css: 2]

  feature "view dashboard page", %{session: session} do
    created_user = insert(:user)

    session
    |> login_as(created_user)
    |> assert_has(css(".page-title", text: "Dashboard"))
  end
end
