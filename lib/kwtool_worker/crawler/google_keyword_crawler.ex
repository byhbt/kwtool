defmodule KwtoolWorker.Crawler.GoogleKeywordCrawler do
  use Oban.Worker,
    queue: :keyword_crawler,
    max_attempts: 3,
    unique: [period: 60, states: Oban.Job.states()]

  alias Kwtool.Crawler.Keywords
  alias Kwtool.Crawler.Providers.Google.{Crawler, Parser}

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id}}) do
    keyword = Keywords.find_by_id!(keyword_id)

    with {:ok, response} <- Crawler.crawl_keyword(keyword.phrase),
         {:ok, parsed_values} <- Parser.parse(response.body),
         {:ok, _keyword_result} <- Keywords.create_keyword_result(keyword, parsed_values) do
      Keywords.mark_as_finished(keyword)
    end

    :ok
  end
end
