defmodule SpecsRunner.Core.RunTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.Core.{Run, Test}

  setup do
    run = Run.start("specs", "tests/specs")
    %{run: run}
  end

  describe "add_test(run, test_key)" do
    test "returns the run with the test added to it", %{run: run} do
      spec_file_path = "spec_a.md"
      scenario_title = "Scenario A"
      test_name = "something works"
      test_key = {spec_file_path, scenario_title, test_name}

      run = Run.add_test(run, test_key)

      assert run.test == %{
               test_key => %Test{
                 status: :pending,
                 errors: nil
               }
             }
    end
  end

  describe "set_test_passed(run, test_key)" do
    test "returns the run with the test marked as passed", %{run: run} do
      spec_file_path = "spec_a.md"
      scenario_title = "Scenario A"
      test_name = "something works"
      test_key = {spec_file_path, scenario_title, test_name}

      run = Run.add_test(run, test_key)
      run = Run.set_test_passed(run, test_key)

      assert run.test[test_key].status == :passed
    end
  end

  describe "set_test_failed(run, test_key, errors)" do
    test "returns the run with the test marked as failed and errors set", %{run: run} do
      spec_file_path = "spec_a.md"
      scenario_title = "Scenario A"
      test_name = "something works"
      test_key = {spec_file_path, scenario_title, test_name}
      errors = ["Error message"]

      run = Run.add_test(run, test_key)
      run = Run.set_test_failed(run, test_key, errors)

      assert run.test[test_key].status == :failed
      assert run.test[test_key].errors == errors
    end
  end
end
