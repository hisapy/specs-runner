defmodule SpecsRunner.TestOutline do
  @moduledoc false

  alias SpecsRunner.Core.Spec

  def from_spec(%Spec{tests: tests}) do
    tests
    |> Map.values()
    |> Enum.sort_by(& &1.position)
    |> Enum.reduce([], fn test, groups ->
      case groups do
        [%{scenario_name: scenario_name} = group | rest]
        when scenario_name == test.scenario_name ->
          [%{group | tests: group.tests ++ [test.name]} | rest]

        groups ->
          [%{scenario_name: test.scenario_name, tests: [test.name]} | groups]
      end
    end)
    |> Enum.reverse()
  end
end
