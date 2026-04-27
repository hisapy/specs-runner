defmodule SpecsRunner.Core.Spec do
  @moduledoc false

  defstruct title: nil,
            path: nil,
            status: :pending

  @type status :: :pending | :passed | :failed

  @type t :: %__MODULE__{
          title: String.t(),
          path: String.t(),
          status: status()
        }

  def new(title, path) do
    %__MODULE__{title: title, path: path}
  end
end
