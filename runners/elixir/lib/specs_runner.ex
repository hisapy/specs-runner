defmodule SpecsRunner do
  @moduledoc false

  require Logger
  alias SpecsRunner.Core.RunInfo
  alias SpecsRunner.ExUnitCLIFormatter
  alias SpecsRunner.SpecsParser

  def run(specs_dir, tests_dir) when is_binary(specs_dir) and is_binary(tests_dir) do
    with :ok <- validate_dir(specs_dir),
         :ok <- validate_dir(tests_dir),
         :ok <- ensure_ex_unit_started() do
      specs_dir = Path.expand(specs_dir)
      tests_dir = Path.expand(tests_dir)

      run_info = RunInfo.new(specs_dir, tests_dir)

      run_info =
        specs_dir
        |> Path.join("**/*.md")
        |> Path.wildcard()
        |> Task.async_stream(
          &SpecsParser.parse_file_stream!(&1, specs_dir, tests_dir),
          ordered: false,
          zip_input_on_exit: true
        )
        |> Enum.reduce(run_info, &process_parsed_spec/2)

      ExUnit.start(
        autorun: false,
        formatters: [ExUnitCLIFormatter],
        run_info: run_info
      )

      ExUnit.run()

      {:ok, %{run_info | end_time: DateTime.utc_now()}}
    end
  end

  defp validate_dir(path) do
    if File.dir?(path), do: :ok, else: {:error, "#{path}: Directory not found"}
  end

  defp process_parsed_spec({:ok, spec}, run_info) when spec.errors == [] do
    test_file_path = Path.join(run_info.tests_dir, spec.test_path)

    if File.exists?(test_file_path) do
      # what happens if the required file has a syntax error?
      Code.unrequire_files([test_file_path])
      Code.require_file(test_file_path)

      RunInfo.add_spec(run_info, spec)
    else
      test_path = Path.relative_to(spec.test_path, run_info.tests_dir)

      header = "[PENDING] #{spec.path} (#{spec.title})"

      lines = [
        "  reason: missing test file",
        "  expected: #{test_path}"
      ]

      IO.puts(
        ExUnitCLIFormatter.colorize(
          :invalid,
          Enum.join([header | lines], "\n")
        )
      )

      run_info
    end
  end

  defp process_parsed_spec({:ok, spec}, run_info) do
    spec_path = spec.path

    header =
      if spec.title,
        do: "[INVALID] #{spec_path} (#{spec.title})",
        else: "[INVALID] #{spec_path}"

    lines = Enum.map(spec.errors, &"  - #{&1}")

    IO.puts(ExUnitCLIFormatter.colorize(:failure, Enum.join([header | lines], "\n")))

    run_info
  end

  defp process_parsed_spec({:exit, {spec_file_path, reason}}, run_info) do
    IO.puts(
      ExUnitCLIFormatter.colorize(
        :failure,
        "Process exited unexpectedly parsing #{spec_file_path} with reason:\n#{inspect(reason)}"
      )
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
