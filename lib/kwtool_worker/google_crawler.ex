defmodule KwtoolWorker.GoogleCrawler do
  use Oban.Worker, queue: :events

  @impl Oban.Worker

  # def perform(%Oban.Job{args: %{"keyword_id" => keyword_id} = args}) do
  # case args do
  #   %{"keyword_id" => keyword_id} ->
  #     keyword = Kwtool.Repo.get(Kwtool.Crawlers.Schemas.Keyword, keyword_id)
  #     Google.get(keyword)

  #   _ ->
  #     IO.inspect(keyword)
  # end

  # :ok
  # end
end
