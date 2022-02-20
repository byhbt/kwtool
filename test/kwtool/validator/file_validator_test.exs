defmodule Kwtool.FileValidatorTest do
  use Kwtool.DataCase, async: true

  defmodule Document do
    use Ecto.Schema

    import Ecto.Changeset

    alias Kwtool.FileValidator

    embedded_schema do
      field :file, :map, virtual: true
    end

    def changeset(document \\ %__MODULE__{}, attrs) do
      document
      |> cast(attrs, [:file])
      |> FileValidator.validate_file_mime_type(:file, ~w(text/csv))
      |> FileValidator.validate_file_size(:file, 5_000)
    end
  end

  describe "validate_file_mime_type/3" do
    test "returns valid changeset given valid upload file mime type" do
      upload_file = fixture_file_upload("3-keywords.csv")

      changeset = Document.changeset(%{file: upload_file})

      assert changeset.valid? == true
    end

    test "returns invalid changeset given upload file mime type is NOT supported" do
      upload_file = fixture_file_upload("invalid-file.png")

      changeset = Document.changeset(%{file: upload_file})

      assert changeset.valid? == false

      assert errors_on(changeset) == %{
               file: ["is not in supported mime types (text/csv)"]
             }
    end
  end

  describe "validate_file_size/3" do
    test "returns valid changeset given valid upload file size" do
      changeset = Document.changeset(%{file: fixture_file_upload("3-keywords.csv")})

      assert changeset.valid? == true
    end

    test "returns invalid changeset given upload file size exceeds max file size limit" do
      changeset = Document.changeset(%{file: fixture_file_upload("big-keywords.csv")})

      assert changeset.valid? == false
      assert errors_on(changeset) == %{file: ["exceeds max file size limit (0.005 MB)"]}
    end
  end
end
