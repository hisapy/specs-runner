defmodule SpecsRunner do
  @moduledoc false

  require Logger
  alias SpecsRunner.Core.RunInfo
  alias SpecsRunner.Output
  alias SpecsRunner.SpecsFile
  alias SpecsRunner.SpecsParser

  def run(specs_dir, tests_dir) when is_binary(specs_dir) and is_binary(tests_dir) do
    exunit_was_already_running? = Process.whereis(ExUnit.Server) != nil

    with :ok <- validate_dir(specs_dir),
         :ok <- validate_dir(tests_dir),
         :ok <- ensure_ex_unit_started() do
      run_info = RunInfo.new(specs_dir, tests_dir)
      Output.run_started(run_info)

      run_info =
        specs_dir
        |> Path.join("**/*.md")
        |> Path.wildcard()
        |> Task.async_stream(&SpecsParser.parse_file_stream!(&1, specs_dir, tests_dir),
          ordered: false,
          zip_input_on_exit: true
        )
        |> Enum.reduce(run_info, &process_parsed_spec/2)

      # Avoid infinite loop if ExUnit was already running before SpecsRunner.run/2 was called
      unless exunit_was_already_running? do
        ExUnit.start(
          autorun: false,
          formatters: [Output.ExUnitFormatter],
          run_info: run_info
        )

        ExUnit.run()
      end

      {:ok, %{run_info | end_time: DateTime.utc_now()}}
    end
  end

  defp validate_dir(path) do
    if File.dir?(path), do: :ok, else: {:error, "#{path}: Directory not found"}
  end

  defp process_parsed_spec({:ok, %{errors: errors} = spec}, run_info) when errors == [] do
    test_file = Path.join(run_info.tests_dir, spec.test_file_path)

    if SpecsFile.exists?(test_file) do
      # what happens if the required file has a syntax error?
      Code.require_file(test_file)

      RunInfo.add_spec(run_info, spec)
    else
      Output.missing_test_file(spec)
      run_info
    end
  end

  defp process_parsed_spec({:ok, spec}, run_info) do
    Output.spec_errors(spec)
    run_info
  end

  defp process_parsed_spec({:exit, {spec_file_path, reason}}, run_info) do
    Output.error(
      "Process exited unexpectedly parsing #{spec_file_path} with reason:\n#{inspect(reason)}"
    )

    run_info
  end

  defp ensure_ex_unit_started do
    case Application.ensure_all_started(:ex_unit) do
      {:ok, _started_apps} -> :ok
      {:error, reason} -> {:error, "Failed to start :ex_unit app: #{inspect(reason)}"}
    end
  end
end
