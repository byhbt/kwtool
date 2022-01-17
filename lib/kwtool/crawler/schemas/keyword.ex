defmodule Kwtool.Crawler.Schemas.Keyword do
  use Ecto.Schema

  import Ecto.Changeset

  alias Kwtool.Account.Schemas.User
  alias Kwtool.Crawler.Schemas.KeywordResult

  @statuses %{
    added: "added",
    in_process: "in_process",
    finished: "finished",
    failed: "failed"
  }

  schema "keywords" do
    field :phrase, :string
    field :status, :string

    belongs_to :user, User

    has_many :keyword_results, KeywordResult

    timestamps()
  end

  def create_changeset(keyword \\ %__MODULE__{}, attrs) do
    keyword
    |> cast(attrs, [:phrase, :status, :user_id])
    |> put_change(:status, "added")
    |> validate_required([:phrase, :status, :user_id])
    |> validate_inclusion(:status, Map.values(@statuses))
    |> assoc_constraint(:user)
  end

  def finished_changeset(%__MODULE__{} = keyword) do
    change(keyword, status: "finished")
  end
end
