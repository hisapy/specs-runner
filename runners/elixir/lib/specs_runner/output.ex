defmodule SpecsRunner.Output do
  @moduledoc false

  alias SpecsRunner.SpecsFile

  @default_colors [
    failure: :red,
    warning: :yellow,
    location_info: [:bright, :black]
  ]

  def run_started(run_info) do
    IO.puts([
      "Specs Runner started\n",
      "Specs directory: #{run_info.specs_dir}\n",
      "Tests directory: #{run_info.tests_dir}\n"
    ])
  end

  def missing_test_file(spec, run_info) do
    spec_path = relative_display_path(spec.path, run_info.specs_dir)

    expected_test_file =
      spec.path
      |> SpecsFile.test_file_path(run_info.specs_dir, run_info.tests_dir)
      |> relative_display_path(run_info.tests_dir)

    IO.puts(
      colorize(
        :warning,
        "[Warn] No test file for #{spec_path}, expected: #{expected_test_file}"
      )
    )
  end

  def spec_errors(spec, run_info) do
    spec_path = relative_display_path(spec.path, run_info.specs_dir)

    header =
      if spec.title, do: "[Error] #{spec_path} (#{spec.title})", else: "[Error] #{spec_path}"

    lines = Enum.map(spec.errors, &"  - #{&1}")
    error(Enum.join([header | lines], "\n"))
  end

  # Mirrors CLIFormatter failure-style output: red text when ANSI is enabled.
  def error(message) do
    IO.puts(colorize(:failure, message))
  end

  defp relative_display_path(path, base_dir) do
    Path.relative_to(path, base_dir)
  end

  defp colorize(key, string) do
    colors = colors()
    escape = colors[:enabled] && colors[key]

    if escape do
      [escape, string, :reset]
      |> IO.ANSI.format_fragment(true)
      |> IO.iodata_to_binary()
    else
      string
    end
  end

  defp colors do
    @default_colors
    |> Keyword.put_new(:enabled, IO.ANSI.enabled?())
  end
end
