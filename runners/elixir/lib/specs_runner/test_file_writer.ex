defmodule SpecsRunner.TestFileWriter do
  @moduledoc false

  def write!(test_path, module_name, outline) do
    File.mkdir_p!(Path.dirname(test_path))
    File.write!(test_path, render(module_name, outline))
  end

  defp render(module_name, outline) do
    body = Enum.map_join(outline, "\n\n", &render_group/1)

    """
    defmodule #{inspect(module_name)} do
      @moduledoc false
      use ExUnit.Case, async: true

    #{body}
    end
    """
  end

  defp render_group(%{scenario_name: nil, tests: tests}) do
    Enum.map_join(tests, "\n", &indent(render_test(&1), 1))
  end

  defp render_group(%{scenario_name: scenario_name, tests: tests}) do
    body = Enum.map_join(tests, "\n", &indent(render_test(&1), 2))

    """
      describe #{inspect(scenario_name)} do
    #{body}
      end\
    """
  end

  defp render_test(name), do: "test #{inspect(name)}"

  defp indent(line, level), do: String.duplicate("  ", level) <> line
end
