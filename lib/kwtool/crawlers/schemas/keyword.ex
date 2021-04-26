defmodule Kwtool.Crawlers.Schemas.Keyword do
  use Ecto.Schema

  import Ecto.Changeset

  schema "keywords" do
    field :phrase, :string
    field :raw_result, :string
    field :status, :integer
    field :user, :id

    timestamps()
    belongs_to :user, Kwtool.Accounts.Schemas.User
  end

  def changeset(keyword \\ %__MODULE__{}, attrs) do
    keyword
    |> cast(attrs, [:phrase, :raw_result, :status, :user])
    |> validate_required([:phrase, :status, :user])
  end
end
