defmodule UploadParserTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Crawlers.UploadParser

  describe "load_from_file/1" do
    test "returns a list of keyword when uploads a valid CSV file" do
      keyword_file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}
      list_of_keywords = UploadParser.load_from_file(keyword_file)

      assert length(list_of_keywords) == 3
    end

    test "returns an error when uploads a invalid CSV file" do
      keyword_file = %Plug.Upload{content_type: "text/jpeg"}

      assert {:error, "Cannot recognize the file extension"} =
               UploadParser.load_from_file(keyword_file)
    end
  end
end
