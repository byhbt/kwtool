defmodule Kwtool.Repo.Migrations.CreateKeywords do
  use Ecto.Migration

  def change do
    create table(:keywords) do
      add :phrase, :string
      add :raw_result, :text
      add :status, :integer
      add :user, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:keywords, [:user])
  end
end
