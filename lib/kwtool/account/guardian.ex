defmodule Kwtool.Account.ErrorHandler do
  # import Plug.Conn

  # @behaviour Guardian.Plug.ErrorHandler

  # @impl Guardian.Plug.ErrorHandler
  # def auth_error(conn, {type, _reason}, _opts) do
  #   body = Jason.encode!(%{message: to_string(type)})
  #   send_resp(conn, 401, body)
  # end


  use KwtoolWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, to_string(type))
  end
end
