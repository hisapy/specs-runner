defmodule SpecsRunner.Output do
  @moduledoc false

  alias SpecsRunner.Core.RunInfo
  alias SpecsRunner.SpecsParser

  defmodule ExUnitFormatter do
    @moduledoc false

    use GenServer

    alias SpecsRunner.Output

    def start_link(opts) do
      GenServer.start_link(__MODULE__, opts)
    end

    @impl GenServer
    def init(opts) do
      {:ok, %{run_info: Keyword.get(opts, :run_info)}}
    end

    @impl GenServer
    def handle_cast({:test_finished, %ExUnit.Test{} = test}, state) do
      Output.test_finished(test, state.run_info)
      {:noreply, state}
    end

    @impl GenServer
    def handle_cast({:suite_finished, _times_us}, state) do
      IO.puts("")
      {:noreply, state}
    end

    @impl GenServer
    def handle_cast(_event, state) do
      {:noreply, state}
    end
  end

  @default_colors [
    success: :green,
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

  def missing_test_file(spec) do
    IO.puts(
      colorize(
        :warning,
        "[Warn] No test file for #{spec.path}, expected: #{spec.test_file_path}"
      )
    )
  end

  def spec_errors(spec) do
    spec_path = spec.path

    header =
      if spec.title, do: "[Error] #{spec_path} (#{spec.title})", else: "[Error] #{spec_path}"

    lines = Enum.map(spec.errors, &"  - #{&1}")
    error(Enum.join([header | lines], "\n"))
  end

  def test_finished(%ExUnit.Test{}, nil), do: :ok

  def test_finished(%ExUnit.Test{state: nil}, _run_info) do
    IO.write(colorize(:success, "."))
    :ok
  end

  def test_finished(%ExUnit.Test{state: {:failed, failures}} = test, run_info) do
    with test_file_path when is_binary(test_file_path) <- test_file_path_from_test(test, run_info),
         %{title: title, path: spec_path} <- RunInfo.find_spec(run_info, test_file_path) do
      header =
        if title do
          "#{spec_path} (#{title})"
        else
          spec_path
        end

      body =
        ExUnit.Formatter.format_test_failure(test, failures, 1, 80, &formatter_callback/2)
        |> String.trim_trailing()

      error(Enum.join([header, body], "\n"))
    end

    :ok
  end

  def test_finished(%ExUnit.Test{}, _run_info), do: :ok

  # Mirrors CLIFormatter failure-style output: red text when ANSI is enabled.
  def error(message) do
    IO.puts(colorize(:failure, message))
  end

  defp formatter_callback(:diff_enabled?, enabled?), do: enabled?

  defp formatter_callback(key, string) when is_binary(string),
    do: colorize(color_key(key), string)

  defp formatter_callback(_key, value), do: value

  defp test_file_path_from_test(%ExUnit.Test{tags: tags}, run_info) do
    tags
    |> Map.get(:file)
    |> SpecsParser.relative_path(run_info.tests_dir)
  end

  defp color_key(:error_info), do: :failure
  defp color_key(:extra_info), do: :location_info
  defp color_key(:location_info), do: :location_info
  defp color_key(:stacktrace_info), do: :location_info
  defp color_key(:test_info), do: :failure
  defp color_key(:test_module_info), do: :failure
  defp color_key(:parameters_info), do: :location_info
  defp color_key(:blame_diff), do: :failure
  defp color_key(_key), do: :failure

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
