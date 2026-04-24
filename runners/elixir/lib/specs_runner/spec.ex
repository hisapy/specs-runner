defmodule SpecsRunner.Spec do
  @moduledoc false

  alias SpecsRunner.{Scenario, Test}

  defstruct title: nil,
            path: nil,
            status: :unknown,
            scenarios: [],
            tests: [],
            error: nil

  @type status :: :unknown | :pending | :passed | :failed

  @type t :: %__MODULE__{
          title: String.t() | nil,
          path: String.t() | nil,
          status: status(),
          scenarios: [SpecsRunner.Scenario.t()],
          tests: [SpecsRunner.Test.t()],
          error: String.t() | nil
        }

  @spec add_test(t(), Test.t()) :: t()
  def add_test(%__MODULE__{} = spec, %Test{} = test) do
    %{spec | tests: spec.tests ++ [test]}
  end

  @spec add_scenario(t(), Scenario.t()) :: t()
  def add_scenario(%__MODULE__{} = spec, %Scenario{} = scenario) do
    %{spec | scenarios: spec.scenarios ++ [scenario]}
  end
end
