defmodule Kwtool.Crawler.Schemas.KeywordResult do
  use Ecto.Schema

  import Ecto.Changeset

  alias Kwtool.Crawler.Schemas.Keyword

  schema "keyword_results" do
    field :top_ads_count, :integer
    field :top_ads_urls, {:array, :string}
    field :all_ads_count, :integer
    field :organic_result_count, :integer
    field :organic_result_urls, {:array, :string}
    field :all_links_count, :integer
    field :html, :string

    belongs_to :keyword, Keyword

    timestamps()
  end

  def create_changeset(keyword_result \\ %__MODULE__{}, attrs) do
    keyword_result
    |> cast(attrs, [
      :keyword_id,
      :top_ads_count,
      :top_ads_urls,
      :all_ads_count,
      :organic_result_count,
      :organic_result_urls,
      :all_links_count,
      :html
    ])
    |> validate_required([
      :keyword_id,
      :top_ads_count,
      :top_ads_urls,
      :all_ads_count,
      :organic_result_count,
      :organic_result_urls,
      :all_links_count,
      :html
    ])
    |> assoc_constraint(:keyword)
  end
end
