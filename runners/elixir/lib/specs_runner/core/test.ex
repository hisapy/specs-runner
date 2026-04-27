defmodule SpecsRunner.Core.Test do
  @moduledoc false

  defstruct name: nil,
            status: :pending,
            error: nil

  @type status :: :pending | :passed | :failed

  @type t :: %__MODULE__{
          name: String.t() | nil,
          status: status(),
          error: String.t() | nil
        }
end
