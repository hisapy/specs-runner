defmodule SpecsRunner.Scenario do
  @moduledoc false

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
end
