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
end
