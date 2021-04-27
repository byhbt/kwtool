defmodule Kwtool.Crawlers.UploadParser do
  alias NimbleCSV.RFC4180, as: CSV

  def load_from_file(%Plug.Upload{content_type: "text/csv"} = keyword_file) do
    keyword_list =
      keyword_file.path
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: false)
      |> Enum.to_list()

    if length(keyword_list) > 0 do
      {:ok, keyword_list}
    else
      {:error, :file_is_empty}
    end
  end

  def load_from_file(_), do: {:error, :file_is_invalid}
end
