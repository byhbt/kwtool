defmodule KwtoolWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import Kwtool.Factory

      alias KwtoolWeb.Router.Helpers, as: Routes
    end
  end
end
