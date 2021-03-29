defmodule Kwtool.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :full_name, :string
    field :company, :string
    field :password, :string
    field :confirm_password

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :full_name, :company, :password, :confirm_password])
    |> validate_required([:email, :full_name, :password, :confirm_password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 4)
  end
end
