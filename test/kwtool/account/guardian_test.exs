defmodule Kwtool.Account.GuardianTest do
  use Kwtool.DataCase, async: true

  alias Kwtool.Account.Guardian

  describe "subject_for_token/2" do
    test "returns resource ID from a given resource" do
      user = insert(:user)

      assert Guardian.subject_for_token(user, %{}) == {:ok, "#{user.id}"}
    end
  end

  describe "resource_from_claims/1" do
    test "given existing user id, returns {:ok, user}" do
      user = insert(:user)
      claims = %{"sub" => user.id}

      assert Guardian.resource_from_claims(claims) == {:ok, user}
    end

    test "given non-existing user, returns {:error, :resource_not_found}" do
      claims = %{"sub" => 0}

      assert Guardian.resource_from_claims(claims) == {:error, :resource_not_found}
    end
  end
end
