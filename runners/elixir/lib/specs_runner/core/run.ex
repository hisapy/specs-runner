defmodule SpecsRunner.Core.Run do
  @moduledoc """
  A run as a noun: the execution of a single specs run, encapsulating all relevant data and state.
  """

  alias SpecsRunner.Core.Spec
  alias SpecsRunner.Core.Test

  @type spec_file_path :: String.t()
  @type scenario_title :: String.t() | nil
  @type test_name :: String.t()

  @type test_key :: {spec_file_path(), scenario_title(), test_name()}

  defstruct specs_dir: nil,
            tests_dir: nil,
            start_time: nil,
            end_time: nil,
            specs: %{},
            tests: %{}

  @type t :: %__MODULE__{
          specs_dir: String.t(),
          tests_dir: String.t(),
          start_time: DateTime.t(),
          end_time: DateTime.t(),
          specs: %{spec_file_path() => Spec.t()},
          tests: %{test_key() => Test.t()}
        }

  def new(specs_dir, tests_dir, start_time \\ DateTime.utc_now()) do
    %__MODULE__{
      specs_dir: specs_dir,
      tests_dir: tests_dir,
      start_time: start_time,
      specs: %{},
      tests: %{}
    }
  end

  def add_spec(%__MODULE__{} = run, spec_file_path) do
    %{run | specs: Map.put(run.specs, spec_file_path, Spec.new(spec_file_path))}
  end

  def set_spec_title(%__MODULE__{} = run, spec_file_path, spec_title) do
    %{run | specs: Map.update(run.specs, spec_file_path, spec_title, &%{&1 | title: spec_title})}
  end

  @spec add_test(SpecsRunner.Core.Run.t(), test_key()) :: SpecsRunner.Core.Run.t()
  def add_test(%__MODULE__{} = run, test_key) when is_tuple(test_key) do
    %{run | tests: Map.put(run.tests, test_key, %Test{})}
  end

  @spec set_test_passed(SpecsRunner.Core.Run.t(), test_key()) :: SpecsRunner.Core.Run.t()
  def set_test_passed(%__MODULE__{} = run, test_key) when is_tuple(test_key) do
    %{run | tests: Map.update!(run.tests, test_key, &%{&1 | status: :passed})}
  end

  @spec set_test_failed(SpecsRunner.Core.Run.t(), test_key(), any()) :: SpecsRunner.Core.Run.t()
  def set_test_failed(%__MODULE__{} = run, test_key, errors) when is_tuple(test_key) do
    %{run | tests: Map.update!(run.tests, test_key, &%{&1 | status: :failed, errors: errors})}
  end

  def add_error(%__MODULE__{} = run, spec_file_path, error_msg) do
    spec = run.specs[spec_file_path]
    new_errors = (spec.errors || []) ++ [error_msg]
    spec = %{spec | errors: new_errors, status: :failed}

    %{run | specs: Map.put(run.specs, spec_file_path, spec)}
  end
end
