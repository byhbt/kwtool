defmodule Kwtool.Repo do
  use Ecto.Repo,
    otp_app: :kwtool,
    adapter: Ecto.Adapters.Postgres
end
