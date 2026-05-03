defmodule SpecsRunner.Core.Spec do
  @moduledoc false

  defstruct title: nil,
            path: nil,
            status: :pending,
            errors: []

  @type status :: :pending | :passed | :failed

  @type t :: %__MODULE__{
          title: String.t(),
          path: String.t(),
          status: status(),
          errors: list()
        }

  def new(spec_file_path, title \\ nil) do
    %__MODULE__{path: spec_file_path, title: title}
  end
end
