defmodule SpecsRunner.Core.Run do
  @moduledoc """
  A run as a noun: the execution of a single specs run, encapsulating all relevant data and state.
  """

  alias SpecsRunner.Core.Test

  @type spec_test_file :: String.t()
  @type scenario_title :: String.t() | nil
  @type test_name :: String.t()

  @type test_key :: {spec_test_file(), scenario_title(), test_name()}

  defstruct specs_dir: nil,
            tests_dir: nil,
            start_time: nil,
            end_time: nil,
            tests: %{}

  @type t :: %__MODULE__{
          specs_dir: String.t(),
          tests_dir: String.t(),
          start_time: DateTime.t(),
          end_time: DateTime.t(),
          tests: %{test_key() => Test.t()}
        }

  def start(specs_dir, tests_dir) do
    %__MODULE__{
      specs_dir: specs_dir,
      tests_dir: tests_dir,
      start_time: DateTime.utc_now(),
      tests: %{}
    }
  end

  def add_test(%__MODULE__{} = run, test_key) do
    %{run | tests: Map.put(run.tests, test_key, %Test{})}
  end

  def set_test_passed(%__MODULE__{} = run, test_key) do
    %{run | tests: Map.update!(run.tests, test_key, &%{&1 | status: :passed})}
  end

  def set_test_failed(%__MODULE__{} = run, test_key, errors) do
    %{run | tests: Map.update!(run.tests, test_key, &%{&1 | status: :failed, errors: errors})}
  end
end
