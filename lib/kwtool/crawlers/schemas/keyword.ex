defmodule Kwtool.Crawlers.Schemas.Keyword do
  use Ecto.Schema

  import Ecto.Changeset

  schema "keywords" do
    field :phrase, :string
    field :raw_result, :string
    field :status, :integer
    field :user, :id

    timestamps()
  end

  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [:phrase, :raw_result, :status])
    |> validate_required([:phrase, :raw_result, :status])
  end
end
