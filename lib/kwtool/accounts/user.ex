defmodule Kwtool.Accounts.User do
  use Ecto.Schema
  use Argon2
  
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :full_name, :string
    field :company, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps()
  end

  def registration_changeset(user, params) do
    user
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes:
      %{encrypted_password: password}} = changeset) do
    change(changeset, add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :full_name, :company, :password, :confirm_password])
    |> validate_required([:email, :full_name, :password, :confirm_password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 4)
  end
end
