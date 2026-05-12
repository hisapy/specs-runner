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

  def add_spec(%__MODULE__{} = run_info, %Spec{path: spec_file_path} = spec)
      when is_binary(spec_file_path) do
    if Map.has_key?(run_info.specs, spec_file_path) do
      raise ArgumentError, "duplicate spec path: #{spec_file_path}"
    end

    %{run_info | specs: Map.put(run_info.specs, spec_file_path, spec)}
  end
end
