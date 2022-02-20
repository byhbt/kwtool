defmodule KwtoolWeb.Api.V1.FallbackController do
  use Phoenix.Controller

  alias Ecto.Changeset
  alias KwtoolWeb.Api.V1.ErrorView

  def call(conn, {:error, :invalid_params, %Changeset{valid?: false} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> render("error.json", %{code: :validation_error, changeset: changeset})
  end
end
