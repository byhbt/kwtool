defmodule KwtoolWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature
      use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney, clear_mock: true

      import Kwtool.Factory
      import Wallaby.Query, only: [button: 1, css: 1, text_field: 1]

      alias KwtoolWeb.Router.Helpers, as: Routes

      @moduletag :feature_test

      def login_as(session, user) do
        session
        |> visit(Routes.session_path(KwtoolWeb.Endpoint, :new))
        |> fill_in(text_field("Email"), with: user.email)
        |> fill_in(css("#user_password"), with: "123456")
        |> click(button("Sign in"))
      end
    end
  end
end
