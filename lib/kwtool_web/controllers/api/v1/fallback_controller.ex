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

  def call(conn, {:error, :not_found, resource}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.json", %{code: :not_found, message: "#{resource} cannot be found."})
  end
end
