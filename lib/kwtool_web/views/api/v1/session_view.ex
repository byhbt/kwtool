defmodule KwtoolWeb.Api.V1.SessionView do
  use JSONAPI.View, type: "logins"

  def fields do
    [
      :jwt,
      :email
    ]
  end
end
