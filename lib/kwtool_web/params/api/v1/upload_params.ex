defmodule KwtoolWeb.Api.V1.UploadParams do
  use KwtoolWeb.Params

  import Kwtool.FileValidator,
    only: [validate_file_mime_type: 3, validate_file_size: 3, validate_file_size_zero: 2]

  alias Kwtool.Crawler.UploadParser

  embedded_schema do
    field :keyword_file, :map, virtual: true
  end

  def changeset(data \\ %__MODULE__{}, params) do
    data
    |> cast(params, [:keyword_file])
    |> validate_required([:keyword_file])
    |> validate_file()
  end

  defp validate_file(changeset) do
    changeset
    |> validate_file_mime_type(:keyword_file, UploadParser.supported_mime_types())
    |> validate_file_size(:keyword_file, UploadParser.max_file_size_in_bytes())
    |> validate_file_size_zero(:keyword_file)
  end
end
