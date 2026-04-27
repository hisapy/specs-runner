defmodule SpecsRunner.Core.Run do
  @moduledoc """
  A run as a noun: the execution of a single specs run, encapsulating all relevant data and state.
  """

  alias SpecsRunner.Core.Spec

  defstruct specs_dir: nil,
            tests_dir: nil,
            start_time: nil,
            end_time: nil,
            specs: nil

  @type t :: %__MODULE__{
          specs_dir: String.t(),
          tests_dir: String.t(),
          start_time: DateTime.t(),
          end_time: DateTime.t(),
          specs: map()
        }

  def start(specs_dir, tests_dir) do
    %__MODULE__{
      specs_dir: specs_dir,
      tests_dir: tests_dir,
      start_time: DateTime.utc_now(),
      specs: %{}
    }
  end

  def add_spec(%__MODULE__{} = run, %Spec{} = spec) do
    %{run | specs: Map.put(run.specs, spec.path, spec)}
  end
end
