defmodule KwtoolWeb.HomePage.ViewUploadPageTest do
  use KwtoolWeb.FeatureCase, async: true

  import Wallaby.Query, only: [button: 1, file_field: 1]

  feature "views upload page", %{session: session} do
    created_user = insert(:user)

    session
    |> login_as(created_user)
    |> visit(Routes.upload_path(KwtoolWeb.Endpoint, :index))
    |> assert_has(button("Upload"))
  end

  feature "uploads the CSV keyword file", %{session: session} do
    created_user = insert(:user)

    session
    |> login_as(created_user)
    |> visit(Routes.upload_path(KwtoolWeb.Endpoint, :index))
    |> attach_file(file_field("keyword_file"), path: "test/support/fixtures/3-keywords.csv")
    |> click(button("Upload"))
    |> assert_has(Query.text("The keyword file is processed successfully!"))
  end
end
