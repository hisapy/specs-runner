defmodule SpecsRunner.Result do
  @moduledoc false

  defstruct specs_dir: nil,
            tests_dir: nil,
            total: 0,
            pending: 0,
            passed: 0,
            failed: 0,
            items: [],
            errors: []

  @type t :: %__MODULE__{
          specs_dir: String.t(),
          tests_dir: String.t(),
          total: non_neg_integer(),
          pending: non_neg_integer(),
          passed: non_neg_integer(),
          failed: non_neg_integer(),
          items: list(),
          errors: list()
        }
end
