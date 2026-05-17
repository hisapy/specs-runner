defmodule SpecsRunner do
  @moduledoc false

  require Logger
  alias SpecsRunner.Core.RunInfo
  alias SpecsRunner.Output
  alias SpecsRunner.SpecsFile
  alias SpecsRunner.SpecsParser

  def run(specs_dir, tests_dir) when is_binary(specs_dir) and is_binary(tests_dir) do
    with :ok <- validate_dir(specs_dir),
         :ok <- validate_dir(tests_dir) do
      run_info = RunInfo.new(specs_dir, tests_dir)
      Output.run_started(run_info)

      exunit_already_running? = exunit_running?()

      unless exunit_already_running? do
        ExUnit.start(
          autorun: false,
          formatters: [Reporter.ExUnitAdapter],
          run_info: run_info
        )
      end

      run_info =
        specs_dir
        |> Path.join("**/*.md")
        |> Path.wildcard()
        |> Task.async_stream(&SpecsParser.parse_file_stream!/1,
          ordered: false,
          zip_input_on_exit: true
        )
        |> Enum.reduce(run_info, &process_parsed_spec/2)

      unless exunit_already_running? do
        ExUnit.run()
      end

      {:ok, %{run_info | end_time: DateTime.utc_now()}}
    end
  end

  defp validate_dir(path) do
    if File.dir?(path), do: :ok, else: {:error, "#{path}: Directory not found"}
  end

  defp process_parsed_spec({:ok, %{errors: errors} = spec}, run_info) when errors == [] do
    test_file = SpecsFile.test_file_path(spec.path, run_info.specs_dir, run_info.tests_dir)

    if SpecsFile.exists?(test_file) do
      # what happens if the required file has a syntax error?
      Code.require_file(test_file)
      RunInfo.add_spec(run_info, %{spec | test_file: test_file})
    else
      Output.missing_test_file(spec, run_info)
      run_info
    end
  end

  defp process_parsed_spec({:ok, spec}, run_info) do
    Output.spec_errors(spec, run_info)
    run_info
  end

  defp process_parsed_spec({:exit, {spec_file_path, reason}}, run_info) do
    Output.error(
      "Process exited unexpectedly parsing #{spec_file_path} with reason:\n#{inspect(reason)}"
    )

    run_info
  end

  defp exunit_running? do
    Process.whereis(ExUnit.Server) != nil
  end
end
