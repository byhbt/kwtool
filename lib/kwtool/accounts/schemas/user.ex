defmodule Kwtool.Accounts.Schemas.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :full_name, :string
    field :company, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    timestamps()

    has_many :keywords, Kwtool.Crawlers.Schemas.Keyword
  end

  def registration_changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:email, :full_name, :company, :password, :password_confirmation])
    |> validate_required([:email, :full_name, :password, :password_confirmation])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password)
    |> hash_password()
  end

  def changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:email, :full_name, :company, :password, :password_confirmation])
    |> validate_required([:email, :full_name])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password, hash_key: :encrypted_password))
  end

  defp hash_password(changeset), do: changeset
end
