defmodule SpecsRunner.Core.Spec do
  @moduledoc false

  alias SpecsRunner.Core.{Scenario, Test}

  defstruct title: nil,
            path: nil,
            status: :pending,
            scenarios: %{},
            tests: %{}

  @type status :: :pending | :passed | :failed

  @type t :: %__MODULE__{
          title: String.t(),
          path: String.t(),
          status: status(),
          scenarios: map(),
          tests: map()
        }

  def new(title, path) do
    %__MODULE__{title: title, path: path}
  end

  def add_test(%__MODULE__{} = spec, %Test{} = test) do
    %{spec | tests: Map.put(spec.tests, test.name, test)}
  end

  def add_scenario(%__MODULE__{} = spec, %Scenario{} = scenario) do
    %{spec | scenarios: Map.put(spec.scenarios, scenario.title, scenario)}
  end
end
