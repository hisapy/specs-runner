defmodule SpecsRunner.Scenario do
  @moduledoc false

  alias SpecsRunner.Test

  defstruct title: nil,
            status: :unknown,
            tests: [],
            error: nil

  @type status :: :unknown | :pending | :passed | :failed

  @type t :: %__MODULE__{
          title: String.t() | nil,
          status: status(),
          tests: [SpecsRunner.Test.t()],
          error: String.t() | nil
        }

  @spec add_test(t(), Test.t()) :: t()
  def add_test(%__MODULE__{} = scenario, %Test{} = test) do
    %{scenario | tests: scenario.tests ++ [test]}
  end
end
