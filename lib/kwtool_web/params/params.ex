defmodule KwtoolWeb.Params do
  @moduledoc """
  Apply to the params module to define params schema with validation.
  """

  @callback changeset(map(), map()) :: Ecto.Changeset.t()
  @optional_callbacks [changeset: 2]

  @type t :: module

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      @primary_key false

      @behaviour KwtoolWeb.Params
    end
  end
end
