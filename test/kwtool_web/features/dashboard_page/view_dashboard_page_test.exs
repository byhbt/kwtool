defmodule KwtoolWeb.HomePage.ViewDashboardPageTest do
  use KwtoolWeb.FeatureCase, async: true

  import Wallaby.Query, only: [css: 2]

  feature "view dashboard page", %{session: session} do
    created_user = insert(:user)

    session
    |> login_as(created_user)
    |> assert_has(css(".h2", text: "Dashboard"))
  end
end
