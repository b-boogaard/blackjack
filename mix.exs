defmodule Blackjack.Mixfile do
  use Mix.Project

  def project do
    [app: :blackjack,
     version: "0.0.2",
     elixir: "~> 1.2",
     name: "blackjack",
     description: "Blackjack game to help me learn Elixir.",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     docs: [extras: ["README.md"]],
     package: package,
     source_url: "https://github.com/b-boogaard/blackjack",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger],
     mod: {Blackjack, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:exrm, "~> 1.0.2"},
      {:ex_doc, "~> 0.11", only: :dev},
      {:earmark, "~> 0.1", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Brian van de Boogaard"],
      licenses: ["Apache 2.0"],
      links: %{
        "Github" => "https://github.com/b-boogaard/blackjack",
        "License" => "http://www.apache.org/licenses/LICENSE-2.0"
      }
    ]
  end
end
