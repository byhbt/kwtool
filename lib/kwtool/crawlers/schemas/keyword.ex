defmodule Kwtool.Crawlers.Schemas.Keyword do
  use Ecto.Schema

  import Ecto.Changeset

  @statuses %{
    added: "added",
    in_process: "in_process",
    finished: "finished",
    done: "done"
  }

  schema "keywords" do
    field :phrase, :string
    field :raw_result, :string
    field :status, :string

    timestamps()

    belongs_to :user, Kwtool.Accounts.Schemas.User
  end

  def create_changeset(keyword \\ %__MODULE__{}, attrs) do
    keyword
    |> cast(attrs, [:phrase, :raw_result, :status, :user_id])
    |> put_change(:status, "added")
    |> validate_required([:phrase, :status, :user_id])
    |> validate_inclusion(:status, Map.values(@statuses))
    |> assoc_constraint(:user)
  end
end
