defmodule SpecsRunner.Core.RunInfoTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.Core.{RunInfo, Spec}

  setup do
    run_info = RunInfo.new("specs", "tests/specs")
    %{run_info: run_info}
  end

  describe "add_spec/2" do
    test "adds a spec keyed by test_path", %{run_info: run_info} do
      spec = %Spec{
        path: "spec_a.md",
        test_path: "spec_a_test.exs",
        title: "Spec A"
      }

      run_info = RunInfo.add_spec(run_info, spec)

      assert run_info.specs["spec_a_test.exs"] == spec
    end

    test "raises when a spec with the same test_path already exists", %{run_info: run_info} do
      first_spec = %Spec{
        path: "spec_a.md",
        test_path: "spec_a_test.exs",
        title: "First"
      }

      second_spec =
        %Spec{
          path: "spec_b.md",
          test_path: "spec_a_test.exs",
          title: "Second"
        }

      run_info = RunInfo.add_spec(run_info, first_spec)

      assert_raise ArgumentError, ~r/duplicate spec path: spec_b\.md/, fn ->
        RunInfo.add_spec(run_info, second_spec)
      end
    end
  end

  describe "fetch_spec!/2" do
    test "finds the spec by test_path", %{run_info: run_info} do
      spec = %Spec{
        path: "spec_a.md",
        test_path: "spec_a_test.exs",
        title: "Spec A"
      }

      run_info = RunInfo.add_spec(run_info, spec)

      assert RunInfo.fetch_spec!(run_info, "spec_a_test.exs") == spec
    end
  end
end
