defmodule SpecsRunner do
  @moduledoc false

  alias SpecsRunner.Core.RunInfo
  alias SpecsRunner.OutputFormatter
  alias SpecsRunner.SpecsParser

  def run(specs_dir, tests_dir) when is_binary(specs_dir) and is_binary(tests_dir) do
    with :ok <- validate_dir(specs_dir),
         :ok <- validate_dir(tests_dir) do
      run_info = RunInfo.new(specs_dir, tests_dir)

      ExUnit.start(
        autorun: false,
        formatters: [OutputFormatter]
      )

      specs_dir
      |> Path.join("**/*.md")
      |> Path.wildcard()
      |> Stream.map(&SpecsParser.parse_file_stream!/1)

      ExUnit.run()

      # spec_file_paths =
      #   specs_dir
      #   |> Path.join("**/*.md")
      #   |> Path.wildcard()

      # run_info = RunInfo.new(specs_dir, tests_dir)

      # spec_file_paths
      # |> Stream.transform(run_info, fn spec_file_path, run_info ->
      #   updated_run_info = SpecsParser.parse_file_stream!(spec_file_path, run_info)
      #   {[spec_file_path], updated_run_info}
      # end)

      # run_info =
      #   Enum.reduce(
      #     spec_file_paths,
      #     RunInfo.new(specs_dir, tests_dir),
      #     fn spec_file_path, run_info ->
      #       SpecsParser.parse_file_stream!(spec_file_path, run_info)
      #     end
      #   )

      # run_info
      # |> valid_spec_paths()
      # |> load_test_files(tests_dir)

      # ExUnit.start(
      #   autorun: false,
      #   formatters: [SpecsRunner.CLIFormatter],
      #   run_info: run_info
      # )

      # ExUnit.run()

      run_info = CLIFormatter.run_info()

      {:ok, %{run_info | end_time: DateTime.utc_now()}}
    end
  end

  defp validate_dir(path) do
    if File.dir?(path), do: :ok, else: {:error, "#{path}: Directory not found"}
  end

  defp valid_spec_paths(run_info) do
    run_info.specs
    |> Enum.reject(fn {_path, spec} -> spec.status == :failed end)
    |> Enum.map(fn {path, _spec} -> path end)
  end

  defp load_test_files(spec_paths, tests_dir) do
    Enum.each(spec_paths, fn spec_path ->
      test_file = spec_path_to_test_file(spec_path, tests_dir)

      if File.exists?(test_file) do
        Code.require_file(test_file)
      end
    end)
  end

  defp spec_path_to_test_file(spec_path, tests_dir) do
    base = spec_path |> Path.basename(".md")
    Path.join(tests_dir, "#{base}_test.exs")
  end
end
