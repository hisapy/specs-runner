defmodule Mix.Tasks.Specs.Run do
  @moduledoc """
  Runs Markdown specifications as acceptance tests.

  This task reads Markdown spec files, matches them to ExUnit test files,
  runs the matched tests, and reports the specification status
  (pending, passing, or failing).

  ## Usage

      mix specs.run

  ## Options

    * `--specs-dir` - directory containing Markdown spec files (required)
    * `--tests-dir` - directory containing ExUnit test files (required)

  ## Examples

      mix specs.run --specs-dir specs/ --tests-dir test/specs/
  """

  use Mix.Task

  @shortdoc "Runs Markdown specs against mapped ExUnit tests"
  @switches [specs_dir: :string, tests_dir: :string]

  @impl Mix.Task
  def run(args) do
    {opts, _argv} = OptionParser.parse!(args, strict: @switches)

    SpecsRunner.run(opts)
  end
end
