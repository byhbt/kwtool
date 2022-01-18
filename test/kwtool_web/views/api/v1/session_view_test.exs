defmodule KwtoolWeb.Api.V1.SessionViewTest do
  use KwtoolWeb.ConnCase, async: true

  test "renders 404.json" do
    assert render(ErrorView, "404.json", []) == %{
             errors: [%{code: :not_found, detail: %{}, message: "Not Found"}]
           }
  end
end
