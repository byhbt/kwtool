defmodule Kwtool.Crawler.UploadParser do
  alias NimbleCSV.RFC4180, as: CSV

  def parse!(%Plug.Upload{content_type: "text/csv"} = keyword_file) do
    keyword_list =
      keyword_file.path
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: false)
      |> Enum.to_list()

    if Enum.any?(keyword_list) do
      {:ok, keyword_list}
    else
      {:error, :file_is_empty}
    end
  end

  def parse!(_), do: raise("Uploaded keyword file is invalid")

  def parse_asset_type(%Plug.Upload{content_type: "csv" <> _}), do: {:ok, :csv}
  def parse_asset_type(_), do: {:error, :unsupported_asset_type}

  def supported_mime_types, do: ~w(text/csv)
  def max_file_size_in_bytes, do: 3_000_000
end
