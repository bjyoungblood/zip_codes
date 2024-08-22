defmodule ZIPCodes.MixProject do
  use Mix.Project

  @version "0.1.0"
  @github_url "https://github.com/bjyoungblood/zip_codes"

  def project do
    [
      app: :zip_codes,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :runtime_tools, :observer, :wx],
      mod: {ZIPCodes.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.34", only: :dev},
      {:nimble_csv, "~> 1.2", only: :dev}
    ]
  end

  defp aliases do
    [
      {:"hex.publish", ["loadpaths", "zip_codes.update", "hex.publish"]}
    ]
  end

  defp docs do
    [
      main: "ZIPCodes",
      extras: ["README.md"],
      source_ref: "v#{@version}",
      source_url: @github_url
    ]
  end

  defp package do
    [
      description: "Look up the latitude and longitude of a ZIP code.",
      licenses: ["MIT"],
      links: %{
        "GitHub" => @github_url
      },
      exclude_patterns: [~r/^lib\/mix/]
    ]
  end
end
