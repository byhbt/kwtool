defmodule KwtoolWeb.Support.ConnHelper do
  alias Kwtool.Account.Guardian

  def with_signed_in_user(%Plug.Conn{} = conn, user) do
    Guardian.Plug.sign_in(conn, user)
  end
end
