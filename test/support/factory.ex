defmodule Kwtool.Factory do
  use ExMachina.Ecto, repo: Kwtool.Repo

  use Kwtool.UserFactory
  # Define your factories in /test/factories and declare it here,
  # eg: `use .Accounts.UserFactory`
end
