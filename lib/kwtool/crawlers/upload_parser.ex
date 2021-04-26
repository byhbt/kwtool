defmodule Kwtool.Crawlers.UploadParser do
  alias NimbleCSV.RFC4180, as: CSV

  def load_from_file(%Plug.Upload{content_type: "text/csv"} = keyword_file) do
    keyword_file.path
    |> File.stream!
    |> CSV.parse_stream(skip_headers: false)
    |> Enum.to_list()
  end

  def load_from_file(_), do: {:error, "Cannot recognize the file extension"}
end
