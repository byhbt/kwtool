defmodule Kwtool.FixtureHelper do
  @fixture_path "test/support/fixtures"

  def fixture_file_upload(path) do
    path = Path.join([@fixture_path, path])

    %Plug.Upload{
      content_type: MIME.from_path(path),
      filename: Path.basename(path),
      path: path
    }
  end
end
