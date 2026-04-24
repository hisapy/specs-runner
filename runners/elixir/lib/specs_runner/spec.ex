defmodule SpecsRunner.Spec do
  @moduledoc false

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
end
