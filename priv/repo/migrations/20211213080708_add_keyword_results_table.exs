defmodule Kwtool.Repo.Migrations.AddKeywordResultsTable do
  use Ecto.Migration

  def change do
    create table(:keyword_results) do
      add :keyword_id, references(:keywords, on_delete: :delete_all)

      add :top_ads_count, :integer, null: false, default: 0
      add :top_ads_urls, {:array, :string}
      add :all_ads_count, :integer, null: false, default: 0
      add :organic_result_count, :integer, null: false, default: 0
      add :organic_result_urls, {:array, :string}
      add :all_links_count, :integer, null: false, default: 0

      add :html, :text, null: false

      timestamps()
    end

    create index(:keyword_results, [:keyword_id])
  end
end
