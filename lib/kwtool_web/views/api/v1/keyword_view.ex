defmodule KwtoolWeb.Api.V1.UploadView do
  use JSONAPI.View, type: "keywords"

  def fields do
    [
      :message
    ]
  end
end
