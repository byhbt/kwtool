defmodule KwtoolWeb.Plugs.SetCurrentUser do
  import Plug.Conn

  alias Kwtool.Accounts.Guardian.Plug

  def init(_options), do: nil

  def call(conn, _params) do
    current_user = Plug.current_resource(conn)

    if current_user do
      conn
      |> assign(:current_user, current_user)
    else
      conn
      |> assign(:current_user, nil)
    end
  end
end
