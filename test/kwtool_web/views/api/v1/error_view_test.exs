defmodule KwtoolWeb.Api.V1.ErrorViewTest do
  use KwtoolWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  alias KwtoolWeb.Api.V1.ErrorView

  test "renders 404.json" do
    assert render(ErrorView, "404.json", []) == %{
             errors: [%{code: :not_found, detail: %{}, message: "Not Found"}]
           }
  end

  test "renders 500.json" do
    assert render(ErrorView, "500.json", []) == %{
             errors: [
               %{code: :internal_server_error, detail: %{}, message: "Internal Server Error"}
             ]
           }
  end

  test "renders custom error message" do
    assert render(ErrorView, "500.json", status: 500, message: "Something went wrong") ==
             %{
               errors: [
                 %{code: :internal_server_error, detail: %{}, message: "Something went wrong"}
               ]
             }
  end
end
