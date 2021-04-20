defmodule KwtoolWeb.HomePage.ViewUploadPageTest do
  use KwtoolWeb.FeatureCase, async: true

  import Wallaby.Query, only: [button: 1, file_field: 1]

  feature "view upload page", %{session: session} do
    created_user = insert(:user)

    session
    |> login_as(created_user)
    |> visit(Routes.upload_path(KwtoolWeb.Endpoint, :index))
    |> attach_file(file_field("keyword_file"), path: "test/fixture/keywords.csv")
    |> click(button("Upload"))
    |> assert_has(Query.text("The keyword file is processed successfully!"))
  end
end
