defmodule Kwtool.Crawlers.Schemas.Keyword do
  use Ecto.Schema

  import Ecto.Changeset

  schema "keywords" do
    field :phrase, :string
    field :raw_result, :string
    field :status, :integer
    timestamps()

    belongs_to :user, Kwtool.Accounts.Schemas.User
  end

  def changeset(keyword \\ %__MODULE__{}, attrs) do
    keyword
    |> cast(attrs, [:phrase, :status, :user_id])
    |> validate_required([:phrase, :status, :user_id])
  end
end
