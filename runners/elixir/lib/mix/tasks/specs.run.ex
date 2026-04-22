defmodule Mix.Tasks.Specs.Run do
  @moduledoc """
  Runs Markdown specifications as acceptance tests.

  This task reads Markdown spec files, matches them to ExUnit test files,
  runs the matched tests, and reports the specification status
  (pending, passing, or failing).

  ## Usage

      mix specs.run

  ## Options

    * `--specs-dir` - directory containing Markdown spec files (optional; defaults to config)
    * `--tests-dir` - directory containing ExUnit test files (optional; defaults to config)

  ## Config

  Defaults can be configured under `:specs_runner`:

      config :specs_runner,
        specs_dir: "specs",
        tests_dir: "test/specs"

  ## Examples

      mix specs.run --specs-dir specs/ --tests-dir test/specs/
  """

  use Mix.Task

  @shortdoc "Runs Markdown specs against mapped ExUnit tests"

  @options [
    specs_dir: :string,
    tests_dir: :string
  ]

  @impl Mix.Task
  def run(args) do
    {opts, _argv} = OptionParser.parse!(args, strict: @options)
    default_opts = Application.get_all_env(:specs_runner)
    options = Keyword.merge(default_opts, opts)

    specs_dir = req_non_empty_str!(options, :specs_dir)
    tests_dir = req_non_empty_str!(options, :tests_dir)

    SpecsRunner.run(specs_dir, tests_dir)
  end

  defp req_non_empty_str!(opts, key) do
    with {:ok, value} <- Keyword.fetch(opts, key),
         true <- is_binary(value) and String.trim(value) != "" do
      value
    else
      _ ->
        value = Keyword.get(opts, key)
        raise ArgumentError, "#{key} must be a non-empty string, got: #{inspect(value)}"
    end
  end
end
