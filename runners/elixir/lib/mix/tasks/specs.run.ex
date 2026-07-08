defmodule Mix.Tasks.Specs.Run do
  @moduledoc """
  Runs Markdown specifications as acceptance tests.

  This task reads Markdown spec files, matches them to ExUnit test files,
  runs the matched tests, and reports the specification status
  (pending, passing, or failing).

  ## Usage

      mix specs.run

  ## Options

    * `--specs-dir` - directory containing Markdown spec files (optional; defaults to "specs")
    * `--tests-dir` - directory containing ExUnit test files (optional; defaults to "test/specs")

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

  @default_specs_dir "specs"
  @default_tests_dir "test/specs"

  @impl Mix.Task
  def run(args) do
    {opts, _argv} = OptionParser.parse!(args, strict: @options)
    env_config = Application.get_all_env(:specs_runner)

    specs_dir = get_config_value(opts, env_config, :specs_dir)
    tests_dir = get_config_value(opts, env_config, :tests_dir)

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

  defp get_config_value(opts, env_config, key) do
    fallback = Keyword.get(env_config, key, default(key))
    value = Keyword.get(opts, key, fallback)

    if is_binary(value) and String.trim(value) != "" do
      value
    else
      raise ArgumentError, "#{key} must be a non-empty string, got: #{inspect(value)}"
    end
  end

  defp default(:specs_dir), do: @default_specs_dir
  defp default(:tests_dir), do: @default_tests_dir
end
