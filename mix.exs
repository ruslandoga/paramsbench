defmodule Paramsbench.MixProject do
  use Mix.Project

  def project do
    [
      app: :paramsbench,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 1.4"},
      {:ecto, "~> 3.12"},
      {:nimble_options, "~> 1.1"},
      {:params, "~> 2.3"},
      {:open_api_spex, "~> 3.21"}
    ]
  end
end
