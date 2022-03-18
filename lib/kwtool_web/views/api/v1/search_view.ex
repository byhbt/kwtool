defmodule KwtoolWeb.Api.V1.SearchView do
  use JSONAPI.View, type: "keywords"

  def fields do
    [
      :phrase,
      :status,
      :inserted_at,
      :updated_at
    ]
  end

  def relationships do
    [
      keyword_results: {KwtoolWeb.Api.V1.KeywordResultView, :include}
    ]
  end
end
