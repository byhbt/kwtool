defmodule Kwtool.Crawlers.Workers.KeywordWorker do
  use Oban.Worker, queue: :events

  @impl Oban.Worker

  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id} = args}) do
    keyword = Kwtool.Repo.get(Kwtool.Crawlers.Schemas.Keyword, keyword_id)

    case args do
      %{"keyword_id" => keyword_id} ->
        IO.inspect(keyword)

      _ ->
        IO.inspect(keyword)
    end

    :ok
  end
end
