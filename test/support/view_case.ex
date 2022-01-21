defmodule KwtoolWeb.ViewCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Phoenix.View
      import Kwtool.Factory
      import KwtoolWeb.ViewCase
      import Phoenix.ConnTest, only: [get: 2, bypass_through: 1]

      alias KwtoolWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint KwtoolWeb.Endpoint
    end
  end

  setup do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
