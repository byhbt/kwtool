defmodule Kwtool.Crawlers.Schemas.KeywordResult do
  use Ecto.Schema

  import Ecto.Changeset

  alias Kwtool.Crawlers.Schemas.Keyword

  schema "keywords" do
    field :top_ads_count, :integer
    field :top_ads_urls, {:array, :string}
    field :all_ads_count, :integer
    field :organic_result_count, :integer
    field :organic_result_urls, {:array, :string}
    field :all_links_count, :integer

    belongs_to :keyword, Keyword
  end

  def create_changeset(keyword \\ %__MODULE__{}, attrs) do
    keyword
    |> cast(attrs, [
      :keyword_id,
      :top_ads_count,
      :top_ads_urls,
      :all_ads_count,
      :organic_result_count,
      :organic_result_urls,
      :all_links_count
    ])
    |> validate_required([
      :keyword_id,
      :top_ads_count,
      :top_ads_urls,
      :all_ads_count,
      :organic_result_count,
      :organic_result_urls,
      :all_links_count
    ])
    |> assoc_constraint(:keyword)
  end
end
