defmodule KwtoolWeb.Plugs.SetCurrentUser do
  import Plug.Conn

  def init(_options), do: nil

  def call(conn, _params) do
    current_user = Kwtool.Accounts.Guardian.Plug.current_resource(conn)

    if current_user do
      conn
      |> assign(:current_user, current_user)
      |> assign(:user_signed_in?, true)
    else
      conn
      |> assign(:current_user, nil)
      |> assign(:user_signed_in?, false)
    end
  end
end
