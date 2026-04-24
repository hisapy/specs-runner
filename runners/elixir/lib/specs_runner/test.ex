defmodule SpecsRunner.Test do
  @moduledoc false

  defstruct title: nil,
            status: :unknown,
            error: nil

  @type status :: :unknown | :pending | :passed | :failed

  @type t :: %__MODULE__{
          title: String.t() | nil,
          status: status(),
          error: String.t() | nil
        }
end
