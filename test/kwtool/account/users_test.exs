defmodule Kwtool.Account.AccountsTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Account.Schemas.User
  alias Kwtool.Account.Users

  @valid_attrs %{
    company: "some company",
    email: "john@example.com",
    full_name: "some full_name",
    password: "some password",
    password_confirmation: "some password"
  }

  @update_attrs %{
    company: "some updated company",
    email: "updated_john@example.com",
    full_name: "some updated full_name",
    password: "some updated password",
    password_confirmation: "some updated password"
  }

  describe "list_users/0" do
    test "returns all users" do
      created_user = insert(:user)

      assert Users.list_users() == [created_user]
    end
  end

  describe "get_user/1" do
    test "returns the user with given Id" do
      created_user = insert(:user)

      assert Users.get_user!(created_user.id) == created_user
    end
  end

  describe "create_user/1" do
    test "creates a user if given valid attributes" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
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

      assert {:ok, %User{} = user_in_db} = Users.update_user(created_user, update_attrs)
      assert user_in_db.company == update_attrs.company
      assert user_in_db.email == update_attrs.email
      assert user_in_db.full_name == update_attrs.full_name
    end

    test "with invalid data returns error changeset" do
      created_user = insert(:user)
      invalid_data_update = %{email: nil, full_name: nil}

      assert {:error, %Ecto.Changeset{}} = Users.update_user(created_user, invalid_data_update)
      assert created_user == Users.get_user!(created_user.id)
    end

    test "updates user credentials with a new password" do
      created_user = insert(:user)

      assert {:ok, %User{} = created_user} = Users.update_user(created_user, @update_attrs)

      assert {:ok, created_user} ==
               Argon2.check_pass(created_user, "some updated password",
                 hash_key: :encrypted_password
               )
    end
  end

  describe "change_user/2" do
    test "returns a user changeset" do
      created_user = insert(:user)

      assert %Ecto.Changeset{} = Users.change_user(created_user)
    end
  end

  describe "delete_user/1" do
    test "removes user from database" do
      created_user = insert(:user)

      assert {:ok, %User{}} = Users.delete_user(created_user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(created_user.id) end
    end
  end
end
