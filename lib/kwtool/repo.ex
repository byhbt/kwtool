defmodule Kwtool.Repo do
  use Ecto.Repo,
    otp_app: :kwtool,
    adapter: Ecto.Adapters.Postgres

  use Phoenix.Pagination, per_page: 15
end
