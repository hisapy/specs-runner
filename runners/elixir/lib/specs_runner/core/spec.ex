defmodule SpecsRunner.Core.Spec do
  @moduledoc false

  alias SpecsRunner.Core.Test

  defstruct title: nil,
            path: nil,
            test_path: nil,
            status: :pending,
            errors: [],
            tests: %{}

  @type status :: :pending | :passed | :failed

  @type t :: %__MODULE__{
          title: String.t(),
          path: String.t(),
          test_path: String.t(),
          status: status(),
          errors: list(),
          tests: map()
        }

  def add_test!(%__MODULE__{} = spec, %Test{} = test) do
    test_key = {test.scenario_name, test.name}

    if Map.has_key?(spec.tests, test_key) do
      raise ArgumentError, "duplicate test in spec: #{inspect(test_key)}"
    end

    %{spec | tests: Map.put(spec.tests, test_key, test)}
  end
end
