defmodule Kwtool.Repo.Migrations.CreateKeywords do
  use Ecto.Migration

  def change do
    create table(:keywords) do
      add :phrase, :string, null: false
      add :raw_result, :text
      add :status, :integer, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:keywords, [:user_id])
  end
end
