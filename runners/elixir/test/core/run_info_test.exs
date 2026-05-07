defmodule SpecsRunner.Core.RunInfoTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.Core.{RunInfo, Spec, Test}

  setup do
    run_info = RunInfo.new("specs", "tests/specs")
    %{run_info: run_info}
  end

  describe "add_spec/2" do
    test "adds a spec with spec_file_path as key", %{run_info: run_info} do
      spec_file_path = "spec_a.md"

      run_info = RunInfo.add_spec(run_info, spec_file_path)

      assert run_info.specs[spec_file_path] == Spec.new(spec_file_path)
    end
  end

  describe "set_spec_title/3" do
    test "sets the title for the spec at spec_file_path", %{run_info: run_info} do
      spec_file_path = "spec_a.md"
      spec_title = "Spec A"

      run_info = RunInfo.add_spec(run_info, spec_file_path)
      run_info = RunInfo.set_spec_title(run_info, spec_file_path, spec_title)

      assert run_info.specs[spec_file_path].title == spec_title
    end
  end

  describe "add_test/2" do
    test "returns the run_info with the test added to it", %{run_info: run_info} do
      spec_file_path = "spec_a.md"
      scenario_title = "Scenario A"
      test_name = "something works"
      test_key = {spec_file_path, scenario_title, test_name}

      run_info = RunInfo.add_test(run_info, test_key)

      assert run_info.tests == %{
               test_key => %Test{
                 status: :pending,
                 errors: nil
               }
             }
    end
  end

  describe "set_test_passed/2" do
    test "returns the run_info with the test marked as passed", %{run_info: run_info} do
      spec_file_path = "spec_a.md"
      scenario_title = "Scenario A"
      test_name = "something works"
      test_key = {spec_file_path, scenario_title, test_name}

      run_info = RunInfo.add_test(run_info, test_key)
      run_info = RunInfo.set_test_passed(run_info, test_key)

      assert run_info.tests[test_key].status == :passed
    end
  end

  describe "set_test_failed/3" do
    test "returns the run_info with the test marked as failed and errors set", %{
      run_info: run_info
    } do
      spec_file_path = "spec_a.md"
      scenario_title = "Scenario A"
      test_name = "something works"
      test_key = {spec_file_path, scenario_title, test_name}
      errors = ["Error message"]

      run_info = RunInfo.add_test(run_info, test_key)
      run_info = RunInfo.set_test_failed(run_info, test_key, errors)

      assert run_info.tests[test_key].status == :failed
      assert run_info.tests[test_key].errors == errors
    end
  end

  describe "add_error/3" do
    test "returns the run_info with the spec errors updated", %{run_info: run_info} do
      spec_file_path = "spec_a.md"
      error_msg = "Error message"

      run_info = RunInfo.add_spec(run_info, spec_file_path)
      run_info = RunInfo.add_error(run_info, spec_file_path, error_msg)

      assert run_info.specs[spec_file_path].errors == [error_msg]
    end
  end
end
