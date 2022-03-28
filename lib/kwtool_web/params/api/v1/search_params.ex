defmodule KwtoolWeb.Api.V1.SearchParams do
  use KwtoolWeb.Params

  embedded_schema do
    field :url, :string
    field :min_ads, :integer
    field :keyword, :string
  end

  def changeset(data \\ %__MODULE__{}, params) do
    data
    |> cast(params, [:url, :min_ads, :keyword])
  end
end
