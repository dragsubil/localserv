defmodule Localserv.Mixfile do
  use Mix.Project

  def project do
    [
      app: :localserv,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  def escript do
    [main_module: Localserv.CLI]
  end
  
  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:cowboy, :plug],
      mod: {Localserv.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.1.0"},
      {:plug, "~> 1.4.3"}
    ]
  end
end
