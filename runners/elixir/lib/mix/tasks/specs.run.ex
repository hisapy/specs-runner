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

    specs_dir = require_non_empty_str!(opts, :specs_dir, default_opts)
    tests_dir = require_non_empty_str!(opts, :tests_dir, default_opts)

    Mix.shell().info([
      "SpecsRunner is running\n",
      "Specs directory: #{specs_dir}\n",
      "Tests directory: #{tests_dir}\n"
    ])

    case SpecsRunner.run(specs_dir, tests_dir) do
      {:ok, _run_info} ->
        # maybe call formatter/reporter to print summary here
        :ok

      {:error, reason} ->
        Mix.raise("specs.run failed: #{inspect(reason)}")
    end
  end

  defp require_non_empty_str!(opts, key, default_opts) do
    value = Keyword.get(opts, key, Keyword.get(default_opts, key))

    if is_binary(value) and String.trim(value) != "" do
      value
    else
      raise ArgumentError, "#{key} must be a non-empty string, got: #{inspect(value)}"
    end
  end
end
