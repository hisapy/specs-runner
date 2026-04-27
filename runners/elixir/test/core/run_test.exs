defmodule SpecsRunner.Core.RunTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.Core.{Run, Spec}

  setup do
    run = Run.start("specs", "tests/specs")
    %{run: run}
  end

  describe "add_spec/2" do
    test "adds a spec to the run", %{run: run} do
      spec = %Spec{title: "Spec A", path: "specs/spec_a.md"}

      run = Run.add_spec(run, spec)

      assert run.specs[spec.path] == spec
    end
  end
end
