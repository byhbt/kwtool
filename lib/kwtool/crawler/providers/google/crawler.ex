defmodule Kwtool.Providers.Google.Crawler do
  use Tesla, only: [:get]

  plug Tesla.Middleware.BaseUrl, "https://www.google.com/"
  plug Tesla.Middleware.Headers, headers()
  plug Tesla.Middleware.Logger

  defp headers do
    [
      {"User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36"},
    ]
  end
end
