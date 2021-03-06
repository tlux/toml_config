defmodule TomlConfigProvider.MixProject do
  use Mix.Project

  def project do
    [
      app: :toml_config,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_apps: [:ex_unit, :mix]],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.travis": :test
      ],
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),

      # Docs
      name: "TOML Config Provider",
      source_url: "https://github.com/tlux/toml_config",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    "A config provider to read TOML configuration files that works with " <>
      "Elixir (1.9+) releases."
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/tlux/toml_config"
      }
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.1.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.20.2", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:toml, "~> 0.5"}
    ]
  end
end
