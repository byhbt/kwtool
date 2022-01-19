defmodule KwtoolWeb.Api.V1.SessionViewTest do
  use KwtoolWeb.ConnCase, async: true

  alias KwtoolWeb.Api.V1.SessionView

  describe "fields/0" do
    test "returns a list of login response fields" do
      assert SessionView.fields() == [
               :jwt,
               :email
             ]
    end
  end
end
