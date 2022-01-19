defmodule KwtoolWeb.Api.V1.ErrorHandler do
  @behaviour Guardian.Plug.ErrorHandler

  use KwtoolWeb, :controller

  alias KwtoolWeb.Api.V1.ErrorView

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json", %{message: "Unauthorized"})
    |> halt()
  end
end
