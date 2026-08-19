defmodule Mix.Tasks.Specs.GenerateTests do
  @moduledoc """
  Generates ExUnit test scaffolding for a single Markdown spec.

  This task reads one Markdown spec file and generates a test file
  (or adds missing test blocks to an existing one), following the
  same matching rules as `specs.run`.

  ## Usage

      mix specs.generate_tests SPEC_PATH

  ## Options

    * `--specs-dir` - directory containing Markdown spec files (optional; defaults to "specs")
    * `--tests-dir` - directory containing ExUnit test files (optional; defaults to "test/specs")

  ## Config

  Defaults can be configured under `:specs_runner`:

      config :specs_runner,
        specs_dir: "specs",
        tests_dir: "test/specs"

  ## Examples

      mix specs.generate_tests specs/orders/refund_flow.md
      mix specs.generate_tests specs/login.md --specs-dir specs/ --tests-dir test/specs/
  """

  use Mix.Task

  @requirements ["app.start"]

  @shortdoc "Generates ExUnit test scaffolding for a single Markdown spec"

  @options [
    specs_dir: :string,
    tests_dir: :string
  ]

  @default_specs_dir "specs"
  @default_tests_dir "test/specs"

  @impl Mix.Task
  def run(args) do
    {opts, argv} = OptionParser.parse!(args, strict: @options)
    env_config = Application.get_all_env(:specs_runner)

    spec_path = get_spec_path!(argv)
    specs_dir = get_config_value(opts, env_config, :specs_dir)
    tests_dir = get_config_value(opts, env_config, :tests_dir)

    case SpecsRunner.generate_tests(spec_path, specs_dir, tests_dir) do
      {:ok, result} ->
        Mix.shell().info(format_result(result))

      {:error, reason} ->
        Mix.raise("specs.generate_tests failed: #{inspect(reason)}")
    end
  end

  defp get_spec_path!([spec_path]), do: spec_path

  defp get_spec_path!([]),
    do:
      Mix.raise(
        "specs.generate_tests requires a spec file path, e.g. mix specs.generate_tests specs/login.md"
      )

  defp get_spec_path!(_argv),
    do: Mix.raise("specs.generate_tests accepts a single spec file path")

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

  defp format_result(%{action: :created, test_path: test_path}) do
    "Generated #{test_path}"
  end

  defp format_result(%{action: :updated, test_path: test_path, added: added}) do
    "Updated #{test_path} (added #{added} test#{if added == 1, do: "", else: "s"})"
  end

  defp format_result(%{action: :unchanged, test_path: test_path}) do
    "#{test_path} is already up to date"
  end
end
