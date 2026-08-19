defmodule SpecsRunner do
  @moduledoc false

  require Logger
  alias SpecsRunner.Core.RunInfo
  alias SpecsRunner.ExUnitCLIFormatter
  alias SpecsRunner.SpecsParser
  alias SpecsRunner.TestFileUpdater
  alias SpecsRunner.TestFileWriter
  alias SpecsRunner.TestOutline

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

  def generate_tests(spec_path, specs_dir, tests_dir)
      when is_binary(spec_path) and is_binary(specs_dir) and is_binary(tests_dir) do
    with :ok <- validate_dir(specs_dir),
         :ok <- validate_file(spec_path) do
      specs_dir = Path.expand(specs_dir)
      tests_dir = Path.expand(tests_dir)

      spec_path
      |> SpecsParser.parse_file_stream!(specs_dir, tests_dir)
      |> generate_tests_for_spec(tests_dir)
    end
  end

  defp generate_tests_for_spec(%{errors: []} = spec, tests_dir) do
    test_path = Path.join(tests_dir, spec.test_path)
    outline = TestOutline.from_spec(spec)

    if File.exists?(test_path) do
      update_test_file(test_path, spec.test_path, outline)
    else
      create_test_file(test_path, spec.test_path, outline)
    end
  end

  defp generate_tests_for_spec(spec, _tests_dir), do: {:error, {:invalid_spec, spec.errors}}

  defp update_test_file(test_path, relative_test_path, outline) do
    before_count = existing_test_count(test_path)
    TestFileUpdater.update!(test_path, outline)
    added = existing_test_count(test_path) - before_count

    if added == 0 do
      {:ok, %{action: :unchanged, test_path: relative_test_path}}
    else
      {:ok, %{action: :updated, test_path: relative_test_path, added: added}}
    end
  end

  defp create_test_file(test_path, relative_test_path, outline) do
    total = Enum.reduce(outline, 0, &(length(&1.tests) + &2))
    module_name = module_name(relative_test_path)
    TestFileWriter.write!(test_path, module_name, outline)
    {:ok, %{action: :created, test_path: relative_test_path, added: total}}
  end

  defp existing_test_count(test_path) do
    test_path
    |> File.read!()
    |> then(&Regex.scan(~r/^\s*test\s+"/m, &1))
    |> length()
  end

  defp validate_file(path) do
    if File.regular?(path), do: :ok, else: {:error, "#{path}: File not found"}
  end

  defp module_name(test_path) do
    segments =
      test_path
      |> Path.rootname()
      |> Path.split()
      |> Enum.map(&Macro.camelize/1)

    Module.concat([__MODULE__ | segments])
  end
end
