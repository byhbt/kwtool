defmodule Kwtool.Factory do
  use ExMachina.Ecto, repo: Kwtool.Repo

  use Kwtool.KeywordFactory
  use Kwtool.KeywordResultFactory
  use Kwtool.UserFactory
end
