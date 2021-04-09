defmodule KwtoolWeb.Plugs.SetCurrentUser do
  import Plug.Conn

  alias Kwtool.Accounts

  def init(params), do: params

  def call(conn, _params) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user = current_user_id && Accounts.get_user!(current_user_id) do
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
