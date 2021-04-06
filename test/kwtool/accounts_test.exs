defmodule Kwtool.AccountsTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Accounts
  alias Kwtool.Accounts.Schemas.User

  @valid_attrs %{company: "some company", email: "john@example.com", full_name: "some full_name", password: "some password", password_confirmation: "some password"}
  @update_attrs %{company: "some updated company", email: "updated_john@example.com", full_name: "some updated full_name", password: "some updated password", password_confirmation: "some updated password"}

  describe "list_users/0" do
    test "returns all users" do
      created_user = insert(:user)

      assert Accounts.list_users() == [created_user]
    end
  end

  describe "get_user/1" do
    test "returns the user with given id" do
      created_user = insert(:user)

      assert Accounts.get_user!(created_user.id) == created_user
    end
  end

  describe "create_user/1" do
    test "with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert {:ok, user} == Argon2.check_pass(user, "some password", hash_key: :encrypted_password)
      assert user.email == @valid_attrs.email
    end
  end

  describe "update_user/2" do
    test "returns the updated user data" do
      created_user = insert(:user)

      update_attrs = %{
        company: "ABC Com",
        email: "mike@example.com",
        full_name: "Mike"
      }

      assert {:ok, %User{} = user_in_db} = Accounts.update_user(created_user, update_attrs)
      assert user_in_db.company == update_attrs.company
      assert user_in_db.email == update_attrs.email
      assert user_in_db.full_name == update_attrs.full_name
    end

    test "with invalid data returns error changeset" do
      created_user = insert(:user)
      invalid_data_update = %{email: nil, full_name: nil}

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(created_user, invalid_data_update)
      assert created_user == Accounts.get_user!(created_user.id)
    end

    test "with a new password" do
      created_user = insert(:user)

      assert {:ok, %User{} = created_user} = Accounts.update_user(created_user, @update_attrs)
      assert {:ok, created_user} == Argon2.check_pass(created_user, "some updated password", hash_key: :encrypted_password)
    end
  end

  describe "change_user/2" do
    test "returns a user changeset" do
      created_user = insert(:user)

      assert %Ecto.Changeset{} = Accounts.change_user(created_user)
    end
  end

  describe "delete_user/1" do
    test "deletes the existing user" do
      created_user = insert(:user)

      assert {:ok, %User{}} = Accounts.delete_user(created_user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(created_user.id) end
    end
  end
end
