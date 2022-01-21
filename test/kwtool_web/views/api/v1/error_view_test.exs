defmodule KwtoolWeb.Api.V1.ErrorViewTest do
  use KwtoolWeb.ViewCase, async: true

  alias KwtoolWeb.Api.V1.ErrorView

  defmodule Device do
    use Ecto.Schema

    import Ecto.Changeset

    schema "devices" do
      field :device_id, :string
      field :operating_system, :string
      field :device_name, :string

      timestamps()
    end

    def changeset(device \\ %__MODULE__{}, attrs) do
      device
      |> cast(attrs, [
        :device_id,
        :operating_system,
        :device_name
      ])
      |> validate_required([
        :device_id,
        :operating_system,
        :device_name
      ])
    end
  end

  describe "render/3" do
    test "renders 404.json" do
      assert render(ErrorView, "404.json", []) == %{
               errors: [%{code: :not_found, detail: %{}, message: "Not Found"}]
             }
    end

    test "renders 500.json" do
      assert render(ErrorView, "500.json", []) == %{
               errors: [
                 %{code: :internal_server_error, detail: %{}, message: "Internal Server Error"}
               ]
             }
    end

    test "given error code and an invalid changeset with multiple errors fields, renders error.json" do
      changeset = Device.changeset(%{})
      error = %{code: :validation_error, changeset: changeset}

      assert render(ErrorView, "error.json", error) ==
               %{
                 errors: [
                   %{
                     code: :validation_error,
                     detail: %{
                       device_id: ["can't be blank"],
                       device_name: ["can't be blank"],
                       operating_system: ["can't be blank"]
                     },
                     message:
                       "Device can't be blank, Device name can't be blank and Operating system can't be blank"
                   }
                 ]
               }
    end

    test "given error code and an invalid changeset with single error field, renders error.json" do
      changeset = Device.changeset(%{device_id: "12345678-9012", device_name: "Android"})
      error = %{code: :validation_error, changeset: changeset}

      assert render(ErrorView, "error.json", error) ==
               %{
                 errors: [
                   %{
                     code: :validation_error,
                     detail: %{operating_system: ["can't be blank"]},
                     message: "Operating system can't be blank"
                   }
                 ]
               }
    end
  end

  describe "render/4" do
    test "renders custom error message" do
      assert render(ErrorView, "500.json", status: 500, message: "Something went wrong") ==
               %{
                 errors: [
                   %{code: :internal_server_error, detail: %{}, message: "Something went wrong"}
                 ]
               }
    end
  end
end
