defmodule Kwtool.Repo.Migrations.RemoveRawResultFieldOnKeywordsTable do
  use Ecto.Migration

  def change do
    alter table("keywords") do
      remove :raw_result, :text
    end
  end
end
