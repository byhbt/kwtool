defmodule KwtoolWeb.Api.V1.UploadParams do
  use KwtoolWeb.Params

  import Kwtool.FileValidator, only: [validate_file_mime_type: 3, validate_file_size: 3]

  alias Kwtool.Crawler.UploadParser

  embedded_schema do
    field :file, :map, virtual: true
  end

  def changeset(data \\ %__MODULE__{}, params) do
    data
    |> cast(params, [:file])
    |> validate_required([:file])
    |> validate_file()
  end

  defp validate_file(changeset) do
    changeset
    |> validate_file_mime_type(:file, UploadParser.supported_mime_types())
    |> validate_file_size(:file, UploadParser.max_file_size_in_bytes())
  end
end
