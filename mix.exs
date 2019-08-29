defmodule PagBackend.MixProject do
  use Mix.Project

  def project do
    [
      app: :pag_backend,
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "PagBackend",
      source_url: "https://github.com/thiagoboeker/quero-ser-paguer-backend/tree/elixir-version",
      docs: [
        main: "PagBackend",
        source_url_pattern: "https://github.com/thiagoboeker/quero-ser-paguer-backend/tree/elixir-version/%{path}#L%{line}"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PagBackend.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:plug_cowboy, "~> 2.1"},
      {:jose, "~> 1.9"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.5", override: true},
      {:ecto, "~> 3.1"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:myxql, "~> 0.2.0"},
      {:scrivener_ecto, "~> 2.0"},
      {:aws, "~> 0.5.0"},
      {:earmark, "~> 1.3", only: :dev},
      {:ex_doc, "~> 0.21", only: :dev}
    ]
  end
end
