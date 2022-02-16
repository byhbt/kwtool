defmodule Kwtool.FileValidator do
  import Ecto.Changeset

  def validate_file_mime_type(changeset, field, mime_types) do
    validate_change(changeset, field, fn field, value ->
      %Plug.Upload{content_type: upload_file_mime_type} = value

      if Enum.member?(mime_types, upload_file_mime_type) do
        []
      else
        [{field, "is not in supported mime types (#{Enum.join(mime_types, ", ")})"}]
      end
    end)
  end

  def validate_file_size(changeset, field, max_file_size_in_bytes) do
    validate_change(changeset, field, fn field, value ->
      %Plug.Upload{path: upload_file_path} = value
      upload_file_size_in_bytes = get_file_size(upload_file_path)

      if upload_file_size_in_bytes <= max_file_size_in_bytes do
        []
      else
        [{field, "exceeds max file size limit (#{format_bytes_in_mb(max_file_size_in_bytes)})"}]
      end
    end)
  end

  defp get_file_size(file_path) do
    {:ok, %{size: upload_file_size_in_bytes}} = File.stat(file_path)

    upload_file_size_in_bytes
  end

  defp format_bytes_in_mb(bytes), do: Float.to_string(bytes / 1_000_000) <> " MB"
end
