defmodule UploadParserTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Crawlers.UploadParser

  describe "parse/1" do
    test "returns a list of keyword when given a valid CSV file" do
      keyword_file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

      assert {:ok, keyword_list} = UploadParser.parse(keyword_file)
      assert length(keyword_list) == 3
    end

    test "returns an error when given an empty CSV file" do
      keyword_file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/empty-keywords.csv"}

      assert UploadParser.parse(keyword_file) == {:error, :file_is_empty}
    end

    test "returns an error when given an invalid CSV file" do
      keyword_file = %Plug.Upload{content_type: "text/jpeg"}

      assert UploadParser.parse(keyword_file) == {:error, :file_is_invalid}
    end
  end
end
