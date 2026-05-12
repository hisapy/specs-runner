defmodule SpecsRunner.Core.RunInfoTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.Core.{RunInfo, Spec}

  setup do
    run_info = RunInfo.new("specs", "tests/specs")
    %{run_info: run_info}
  end

  describe "add_spec/2" do
    test "adds a spec keyed by spec.path", %{run_info: run_info} do
      spec = %Spec{path: "spec_a.md", title: "Spec A"}

      run_info = RunInfo.add_spec(run_info, spec)

      assert run_info.specs[spec.path] == spec
    end

    test "raises when a spec with the same path already exists", %{run_info: run_info} do
      spec_path = "spec_a.md"
      first_spec = %Spec{path: spec_path, title: "First"}
      second_spec = %Spec{path: spec_path, title: "Second"}

      run_info = RunInfo.add_spec(run_info, first_spec)

      assert_raise ArgumentError, ~r/duplicate spec path: spec_a\.md/, fn ->
        RunInfo.add_spec(run_info, second_spec)
      end
    end
  end
end
