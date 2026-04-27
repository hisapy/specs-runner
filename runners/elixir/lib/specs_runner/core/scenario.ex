defmodule SpecsRunner.Core.Scenario do
  @moduledoc false

  alias SpecsRunner.Core.Test

  defstruct title: nil,
            status: :pending,
            tests: %{}

  @type status :: :pending | :passed | :failed

  @type t :: %__MODULE__{
          title: String.t() | nil,
          status: status(),
          tests: map()
        }

  def new(title) do
    %__MODULE__{title: title}
  end

  def add_test(%__MODULE__{} = scenario, %Test{} = test) do
    %{scenario | tests: Map.put(scenario.tests, test.name, test)}
  end
end
