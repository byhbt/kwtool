defmodule UploadParserTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Crawlers.UploadParser

  describe "load_from_file/1" do
    test "returns a list of keyword when given a valid CSV file" do
      keyword_file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

      assert {:ok, keyword_list} = UploadParser.load_from_file(keyword_file)
      assert length(keyword_list) == 3
    end

    test "returns an error when given an empty CSV file" do
      keyword_file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/empty-keywords.csv"}

      assert {:error, :file_is_empty} == UploadParser.load_from_file(keyword_file)
    end

    test "returns an error when given an invalid CSV file" do
      keyword_file = %Plug.Upload{content_type: "text/jpeg"}

      assert {:error, :file_is_invalid} == UploadParser.load_from_file(keyword_file)
    end
  end
end
