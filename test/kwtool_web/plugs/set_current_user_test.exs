defmodule KwtoolWeb.Plugs.SetCurrentUserTest do
  use KwtoolWeb.ConnCase, async: true

  import KwtoolWeb.Plugs.SetCurrentUser

  test "retrieves user data from session when it exists" do
    created_user = insert(:user)

    conn =
      build_conn()
      |> init_test_session(current_user_id: created_user.id)
      |> call(%{})

    assert conn.assigns.current_user.id == created_user.id
    assert conn.assigns.current_user.email == created_user.email
    assert conn.assigns.user_signed_in? == true
  end

  test "retrieves user data from session when it does NOT exists" do
    conn =
      build_conn()
      |> init_test_session(%{})
      |> call(%{})

    assert conn.assigns.current_user == nil
    assert conn.assigns.user_signed_in? == false
  end
end
