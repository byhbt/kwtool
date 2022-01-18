defmodule KwtoolWeb.CheckEmptyBodyParamsPlug do
  @behaviour Plug

  import Phoenix.Controller, only: [put_view: 2, render: 3]
  import Plug.Conn

  alias KwtoolWeb.Api.V1.ErrorView

  def init(opts), do: opts

  def call(%{body_params: body_params} = conn, _opts) when body_params == %{} do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json", %{message: "Missing body params"})
    |> halt()
  end

  def call(conn, _opts), do: conn
end
