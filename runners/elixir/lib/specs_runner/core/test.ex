defmodule SpecsRunner.Core.Test do
  @moduledoc false

  defstruct name: nil,
            scenario_name: nil,
            status: :pending,
            errors: nil

  @type status :: :pending | :passed | :failed

  @type t :: %__MODULE__{
          name: String.t() | nil,
          scenario_name: String.t() | nil,
          status: status(),
          errors: term() | nil
        }
end
