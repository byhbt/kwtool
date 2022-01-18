# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kwtool,
  ecto_repos: [Kwtool.Repo]

# Configures the endpoint
config :kwtool, KwtoolWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HuHBcv0u6+f2oJalUQycD8aYnoMq4+EFiIL5a4s/jkKJELdET+i+v/APP0HLwVtF",
  render_errors: [view: KwtoolWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Kwtool.PubSub,
  live_view: [signing_salt: "W+K81ela"]

config :kwtool, Kwtool.Account.Guardian,
  issuer: "kwtool",
  secret_key: "y00rP0vBWqQBbXREQWmFJfyKFBj1QGIMQJL"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kwtool, Oban,
  repo: Kwtool.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [
    default: 10,
    keyword_crawler: 10
  ]

config :tesla, adapter: Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
