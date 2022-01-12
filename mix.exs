defmodule Kwtool.MixProject do
  use Mix.Project

  def project do
    [
      app: :kwtool,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        lint: :test,
        coverage: :test,
        coveralls: :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Kwtool.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(:dev), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:argon2_elixir, "~> 2.0"},
      {:credo, "~> 1.5.5", [only: [:dev, :test], runtime: false]},
      {:dialyxir, "~> 1.1.0", [only: [:dev], runtime: false]},
      {:ecto_sql, "~> 3.4"},
      {:ex_machina, "~> 2.7.0", [only: [:dev, :test]]},
      {:excoveralls, "~> 0.14.0", [only: :test]},
      {:exvcr, "~> 0.13.2", [only: :test]},
      {:faker_elixir_octopus, "~> 1.0.0", only: [:dev, :test]},
      {:floki, "~> 0.32.0"},
      {:gettext, "~> 0.19.0"},
      {:guardian, "~> 2.0"},
      {:hackney, "~> 1.17"},
      {:jason, "~> 1.0"},
      {:mimic, "~> 1.4.0", [only: :test]},
      {:nimble_csv, "~> 1.1.0"},
      {:httpoison, "~> 1.8"},
      {:oban, "~> 2.6.1"},
      {:phoenix, "~> 1.5.8"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_pagination, "~> 0.7.0"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:sobelow, "~> 0.11.1", [only: [:dev, :test], runtime: false]},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:tesla, "~> 1.4"},
      {:wallaby, "~> 0.29.0", [only: :test, runtime: false]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "assets.compile": &compile_assets/1,
      coverage: ["coveralls.html --raise"],
      codebase: [
        "deps.unlock --check-unused",
        "format --check-formatted",
        "credo --strict",
        "sobelow --config",
        "cmd ./assets/node_modules/.bin/stylelint --color ./assets/css"
      ],
      "codebase.fix": [
        "format",
        "cmd ./assets/node_modules/.bin/stylelint --color --fix ./assets/css"
      ],
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp compile_assets(_) do
    Mix.shell().cmd("npm run --prefix assets build:dev", quiet: true)
  end
end
