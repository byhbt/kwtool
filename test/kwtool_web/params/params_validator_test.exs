defmodule KwtoolWeb.ParamsValidatorTest do
  use Kwtool.DataCase, async: true

  alias KwtoolWeb.ParamsValidator

  defmodule CreateSettingsParams do
    use KwtoolWeb.Params

    embedded_schema do
      field :language, :string
      field :theme, :string
    end

    def changeset(data \\ %__MODULE__{}, params) do
      data
      |> cast(params, [:language, :theme])
      |> validate_required([:language, :theme])
    end
  end

  defmodule CreateKeywordsParams do
    use KwtoolWeb.Params

    embedded_schema do
      field(:content, :string)
      field(:count, :integer)
    end

    def changeset(data \\ %__MODULE__{}, params) do
      data
      |> cast(params, [:content, :count])
      |> validate_required([:content, :count])
    end
  end

  defmodule CreateUserParams do
    use KwtoolWeb.Params

    embedded_schema do
      field(:name, :string)
      field(:email, :string)
      embeds_one(:settings, CreateSettingsParams)
      embeds_many(:assets, CreateKeywordsParams)
    end

    def changeset(data \\ %__MODULE__{}, params) do
      data
      |> cast(params, [:name, :email])
      |> cast_embed(:settings, required: true)
      |> cast_embed(:assets)
      |> validate_required([:name, :email])
      |> validate_format(:email, ~r/@/)
    end

    def custom_changeset(data \\ %__MODULE__{}, params) do
      data
      |> cast(params, [:name, :email])
      |> validate_required([:name, :email])
      |> validate_format(:email, ~r/@/)
    end
  end

  describe "validate/2" do
    test "returns {:ok, validated_params} given valid params" do
      params = %{
        "name" => "John Doe",
        "email" => "john@mail.com",
        "settings" => %{"language" => "th", "theme" => "dark"},
        "assets" => [
          %{"content" => "perspiciatis unde", "count" => 1},
          %{"content" => "natus error sit voluptatem accusantium", "count" => 2}
        ]
      }

      assert {:ok, validated_params} = ParamsValidator.validate(params, for: CreateUserParams)

      assert validated_params == %{
               name: "John Doe",
               email: "john@mail.com",
               settings: %{language: "th", theme: "dark"},
               assets: [
                 %{content: "perspiciatis unde", count: 1},
                 %{content: "natus error sit voluptatem accusantium", count: 2}
               ]
             }
    end

    test "returns {:ok, validated_params} given valid params with custom changeset name" do
      params = %{
        "name" => "John Doe",
        "email" => "john@mail.com"
      }

      assert {:ok, validated_params} =
               ParamsValidator.validate(params, :custom_changeset, for: CreateUserParams)

      assert validated_params == %{
               name: "John Doe",
               email: "john@mail.com"
             }
    end

    test "raises UndefinedFunctionError given a non-existing custom changeset name" do
      assert_raise UndefinedFunctionError, fn ->
        ParamsValidator.validate(%{}, :not_exist_changeset, for: CreateUserParams)
      end
    end

    test "returns {:error, :invalid_params, changeset} given invalid params" do
      params = %{"email" => "invalid-mail.com"}

      assert {:error, :invalid_params, changeset} =
               ParamsValidator.validate(params, for: CreateUserParams)

      assert changeset.valid? == false
      assert changeset.action == :validate

      assert errors_on(changeset) == %{
               name: ["can't be blank"],
               email: ["has invalid format"],
               settings: ["can't be blank"]
             }
    end
  end
end
