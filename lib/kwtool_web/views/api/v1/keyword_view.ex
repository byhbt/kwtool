defmodule KwtoolWeb.Api.V1.KeywordView do
  use JSONAPI.View, type: "keywords"

  def fields do
    [
      :id,
      :phrase,
      :status,
      :inserted_at,
      :updated_at
    ]
  end
end
