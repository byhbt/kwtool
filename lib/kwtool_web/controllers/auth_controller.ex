defmodule KwtoolWeb.AuthController do
  use KwtoolWeb, :controller

  def sign_up(conn, _params) do
    render(conn, "sign_up.html",
      layout: { KwtoolWeb.LayoutView, "auth.html" }
    )
  end
end
