defmodule SpecsRunner.Core.RunInfo do
  @moduledoc """
  The execution state for a single specs run, encapsulating all relevant data and state.
  """

  alias SpecsRunner.Core.Spec

  defstruct specs_dir: nil,
            tests_dir: nil,
            start_time: nil,
            end_time: nil,
            specs: %{}

  @type t :: %__MODULE__{
          specs_dir: String.t(),
          tests_dir: String.t(),
          start_time: DateTime.t(),
          end_time: DateTime.t(),
          specs: %{String.t() => Spec.t()}
        }

  def new(specs_dir, tests_dir, start_time \\ DateTime.utc_now()) do
    %__MODULE__{
      specs_dir: specs_dir,
      tests_dir: tests_dir,
      start_time: start_time,
      specs: %{}
    }
  end

  def add_spec(%__MODULE__{} = run_info, %Spec{test_path: test_path} = spec)
      when is_binary(test_path) do
    if Map.has_key?(run_info.specs, test_path) do
      raise ArgumentError, "duplicate spec path: #{spec.path}"
    end

    %{run_info | specs: Map.put(run_info.specs, test_path, spec)}
  end

  def fetch_spec!(%__MODULE__{} = run_info, test_path) when is_binary(test_path) do
    Map.fetch!(run_info.specs, test_path)
  end
end
