defmodule Kwtool.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string, unique: true, null: false
    field :full_name, :string
    field :company, :string
    field :confirm_password, :string, null: false
    field :password, :string, null: false

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :full_name, :company, :password, :confirm_password])
    |> validate_required([:email, :full_name, :company, :password, :confirm_password])
  end
end
