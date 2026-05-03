defmodule SpecsRunner.Core.RunTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.Core.{Run, Spec, Test}

  setup do
    run = Run.new("specs", "tests/specs")
    %{run: run}
  end

  describe "add_spec/2" do
    test "adds a spec with spec_file_path as key", %{run: run} do
      spec_file_path = "spec_a.md"

      run = Run.add_spec(run, spec_file_path)

      assert run.specs[spec_file_path] == Spec.new(spec_file_path)
    end
  end

  describe "set_spec_title/3" do
    test "sets the title for the spec at spec_file_path", %{run: run} do
      spec_file_path = "spec_a.md"
      spec_title = "Spec A"

      run = Run.add_spec(run, spec_file_path)
      run = Run.set_spec_title(run, spec_file_path, spec_title)

      assert run.specs[spec_file_path].title == spec_title
    end
  end

  describe "add_test/2" do
    test "returns the run with the test added to it", %{run: run} do
      spec_file_path = "spec_a.md"
      scenario_title = "Scenario A"
      test_name = "something works"
      test_key = {spec_file_path, scenario_title, test_name}

      run = Run.add_test(run, test_key)

      assert run.tests == %{
               test_key => %Test{
                 status: :pending,
                 errors: nil
               }
             }
    end
  end

  describe "set_test_passed/2" do
    test "returns the run with the test marked as passed", %{run: run} do
      spec_file_path = "spec_a.md"
      scenario_title = "Scenario A"
      test_name = "something works"
      test_key = {spec_file_path, scenario_title, test_name}

      run = Run.add_test(run, test_key)
      run = Run.set_test_passed(run, test_key)

      assert run.tests[test_key].status == :passed
    end
  end

  describe "set_test_failed/3" do
    test "returns the run with the test marked as failed and errors set", %{run: run} do
      spec_file_path = "spec_a.md"
      scenario_title = "Scenario A"
      test_name = "something works"
      test_key = {spec_file_path, scenario_title, test_name}
      errors = ["Error message"]

      run = Run.add_test(run, test_key)
      run = Run.set_test_failed(run, test_key, errors)

      assert run.tests[test_key].status == :failed
      assert run.tests[test_key].errors == errors
    end
  end

  describe "add_error/3" do
    test "returns the run with the test marked as failed and errors set", %{run: run} do
      spec_file_path = "spec_a.md"
      error_msg = "Error message"

      run = Run.add_error(run, spec_file_path, error_msg)

      assert run.specs[spec_file_path].errors == [error_msg]
    end
  end
end
