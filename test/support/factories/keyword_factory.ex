defmodule Kwtool.KeywordFactory do
  defmacro __using__(_opts) do
    quote do
      def keyword_factory do
        %Kwtool.Crawler.Schemas.Keyword{
          phrase:
            FakerElixir.Helper.pick([
              "desk lamp",
              "amazon echo",
              "kindle paper white 2022",
              "cheap flights"
            ]),
          status: FakerElixir.Helper.pick(["added", "in_process", "finished", "failed"]),
          user: build(:user)
        }
      end
    end
  end
end
