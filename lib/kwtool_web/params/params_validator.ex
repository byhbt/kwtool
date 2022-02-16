defmodule KwtoolWeb.ParamsValidator do
  @moduledoc """
  Helper module for validating given request params with params module
  """

  alias Ecto.Changeset
  alias KwtoolWeb.Params

  @spec validate(map(), atom(), [{:for, Params.t()}]) ::
          {:ok, map()} | {:error, :invalid_params, Ecto.Changeset.t()}
  def validate(params, changeset_method \\ :changeset, for: params_module) do
    params_module
    |> Kernel.apply(changeset_method, [params])
    |> handle_changeset()
  end

  defp handle_changeset(%Changeset{valid?: true} = changeset),
    do: {:ok, extract_changes(changeset)}

  defp handle_changeset(changeset), do: {:error, :invalid_params, put_action(changeset)}

  defp extract_changes(%Changeset{} = changeset) do
    Enum.reduce(changeset.changes, %{}, fn {key, value}, params ->
      Map.put(params, key, extract_changes(value))
    end)
  end

  defp extract_changes([%Changeset{} | _] = changesets),
    do: Enum.map(changesets, &extract_changes/1)

  defp extract_changes(value), do: value

  defp put_action(%Changeset{} = changeset), do: Map.put(changeset, :action, :validate)
end
