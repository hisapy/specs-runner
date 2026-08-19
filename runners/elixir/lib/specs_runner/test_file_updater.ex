defmodule SpecsRunner.TestFileUpdater do
  @moduledoc false

  def update!(test_path, outline) do
    lines = test_path |> File.read!() |> String.split("\n")
    updated = Enum.reduce(outline, lines, &apply_group/2)
    File.write!(test_path, Enum.join(updated, "\n"))
  end

  defp apply_group(%{scenario_name: nil, tests: tests}, lines) do
    missing = missing_tests(lines, nil, tests)
    insert_bare_tests(lines, missing)
  end

  defp apply_group(%{scenario_name: scenario_name, tests: tests}, lines) do
    case describe_range(lines, scenario_name) do
      nil ->
        append_describe(lines, scenario_name, tests)

      {_start_index, end_index} ->
        missing = missing_tests(lines, scenario_name, tests)
        insert_tests_before(lines, end_index, missing, indent: 2)
    end
  end

  defp missing_tests(lines, scenario_name, tests) do
    existing = existing_test_names(lines, scenario_name)
    Enum.reject(tests, &(&1 in existing))
  end

  defp insert_bare_tests(lines, []), do: lines

  defp insert_bare_tests(lines, missing) do
    insert_at = Enum.find_index(lines, &describe_line?/1)
    new_lines = Enum.map(missing, &"  test #{inspect(&1)}")

    case insert_at do
      nil ->
        List.insert_at(lines, last_end_index(lines), new_lines) |> List.flatten()

      insert_at ->
        List.insert_at(lines, insert_at, new_lines ++ [""]) |> List.flatten()
    end
  end

  defp insert_tests_before(lines, _index, [], _opts), do: lines

  defp insert_tests_before(lines, index, missing, indent: level) do
    pad = String.duplicate("  ", level)
    new_lines = [""] ++ Enum.map(missing, &"#{pad}test #{inspect(&1)}")
    List.insert_at(lines, index, new_lines) |> List.flatten()
  end

  defp append_describe(lines, scenario_name, tests) do
    block =
      [~s(  describe #{inspect(scenario_name)} do)] ++
        Enum.map(tests, &"    test #{inspect(&1)}") ++
        ["  end"]

    insert_at = last_end_index(lines)
    List.insert_at(lines, insert_at, [""] ++ block) |> List.flatten()
  end

  defp existing_test_names(lines, nil) do
    lines
    |> Enum.take_while(&(not describe_line?(&1)))
    |> Enum.flat_map(&test_name/1)
  end

  defp existing_test_names(lines, scenario_name) do
    case describe_range(lines, scenario_name) do
      nil ->
        []

      {start_index, end_index} ->
        lines |> Enum.slice((start_index + 1)..(end_index - 1)) |> Enum.flat_map(&test_name/1)
    end
  end

  defp describe_range(lines, scenario_name) do
    case Enum.find_index(lines, &(describe_line?(&1) and describe_name(&1) == scenario_name)) do
      nil -> nil
      start_index -> {start_index, find_block_end(lines, start_index)}
    end
  end

  defp describe_line?(line), do: Regex.match?(~r/^\s*describe\s+".*"\s+do\s*$/, line)

  defp describe_name(line) do
    [_, name] = Regex.run(~r/^\s*describe\s+"(.*)"\s+do\s*$/, line)
    name
  end

  defp test_name(line) do
    case Regex.run(~r/^\s*test\s+"((?:[^"\\]|\\.)*)"/, line) do
      [_, name] -> [Macro.unescape_string(name)]
      nil -> []
    end
  end

  # Finds the line index of the `end` that closes the `describe` block
  # starting at `start_index`, accounting for nested `do ... end` blocks.
  defp find_block_end(lines, start_index) do
    lines
    |> Enum.drop(start_index + 1)
    |> Enum.with_index(start_index + 1)
    |> Enum.reduce_while(1, fn {line, index}, depth ->
      depth =
        cond do
          Regex.match?(~r/\bdo\s*$/, line) -> depth + 1
          String.trim(line) == "end" -> depth - 1
          true -> depth
        end

      if depth == 0, do: {:halt, index}, else: {:cont, depth}
    end)
  end

  defp last_end_index(lines) do
    lines
    |> Enum.with_index()
    |> Enum.filter(fn {line, _index} -> String.trim(line) == "end" end)
    |> List.last()
    |> elem(1)
  end
end
