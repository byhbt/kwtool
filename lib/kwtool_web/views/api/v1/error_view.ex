defmodule KwtoolWeb.Api.V1.ErrorView do
  use KwtoolWeb, :view

  alias Ecto.Changeset

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    build_error_response(
      code: status_code_from_template(template),
      detail: %{},
      message: Phoenix.Controller.status_message_from_template(template)
    )
  end

  def render("error.json", %{code: code, changeset: %Changeset{} = changeset}) do
    build_error_response(
      code: code,
      detail: translate_errors(changeset),
      message: build_changeset_error_message(changeset)
    )
  end

  def render("error.json", %{code: code, message: message}),
    do: build_error_response(code: code, detail: %{}, message: message)

  defp build_changeset_error_message(%Changeset{} = changeset) do
    changeset
    |> translate_errors()
    |> Enum.flat_map(fn {key, messages} ->
      Enum.map(messages, &"#{Phoenix.Naming.humanize(key)} #{&1}")
    end)
    |> to_sentence()
  end

  defp to_sentence([]), do: ""
  defp to_sentence([message]), do: message

  defp to_sentence(messages) do
    sentence =
      messages
      |> Enum.slice(0..(length(messages) - 2))
      |> Enum.join(", ")

    "#{sentence} and #{List.last(messages)}"
  end

  defp build_error_response(code: code, detail: detail, message: message) do
    %{
      errors: [
        %{
          code: code,
          detail: detail,
          message: message
        }
      ]
    }
  end

  defp translate_errors(changeset), do: Changeset.traverse_errors(changeset, &translate_error/1)
end
