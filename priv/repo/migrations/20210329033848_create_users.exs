defmodule Kwtool.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, unique: true, null: false
      add :full_name, :string
      add :company, :string
      add :password, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
