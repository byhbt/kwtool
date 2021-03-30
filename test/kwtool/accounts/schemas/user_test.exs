defmodule Kwtool.Accounts.Schemas.UserTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Accounts.Schemas.User

  describe "registration_changeset/2" do
    test "returns valid registration changeset when given valid attributes" do
      password_inputs = %{password: "123456", password_confirmation: "123456"}
      attrs = params_for(:user, password_inputs)
      changeset = User.registration_changeset(attrs)

      assert changeset.valid?
      assert changeset.changes.email == attrs.email
    end

    test "returns invalid changeset when given invalid email attributes" do
      override_email_attr = %{email: "invalid_email"}
      attrs = params_for(:user, override_email_attr)
      changeset = User.registration_changeset(attrs)

      refute changeset.valid?
      refute Map.has_key?(changeset.changes, :encrypted_password)
      assert changeset.changes.email == attrs.email
    end

    test "returns invalid when the password confirmation does NOT match" do
      different_password_confirm = %{password: "123456", password_confirmation: "654321"}
      attrs = params_for(:user, different_password_confirm)
      changeset = User.registration_changeset(attrs)
      {message, _} = {"does not match password!", [validation: :confirmation]}

      refute changeset.valid?
      assert message == "does not match password!"
    end

    test "returns hashed password when given valid attributes" do
      password_inputs = %{password: "123asd", password_confirmation: "123asd"}
      attrs = params_for(:user, password_inputs)
      changeset = User.registration_changeset(attrs)

      assert changeset.valid?
      assert Argon2.verify_pass("123asd", changeset.changes.encrypted_password)
      assert Map.has_key?(changeset.changes, :encrypted_password)
    end
  end
end
