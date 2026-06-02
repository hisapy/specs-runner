defmodule SpecsRunner.Specs.RunTest do
  @moduledoc false
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  setup_all do
    [
      output:
        capture_io(fn ->
          # The specs dir and tests dir are configured in config/test.exs
          Mix.Task.reenable("specs.run")
          Mix.Task.run("specs.run", [])
        end)
        |> IO.iodata_to_binary()
    ]
  end

  describe "Invalid specs error" do
    test "when the specs title is missing or repeated", %{output: output} do
      assert output =~ "[INVALID] missing_title.md\n  - Title not found in spec file"
      assert output =~ "[INVALID] repeated_title.md (Repeated Title Spec)\n  - Title is repeated"
    end

    test "when the acceptance criteria section is missing or repeated", %{output: output} do
      assert output =~
               "[INVALID] missing_acceptance_criteria.md (Missing Acceptance Criteria)\n  - Acceptance criteria section not found"

      assert output =~
               "[INVALID] repeated_acceptance_criteria.md (Repeated Acceptance Criteria Section)\n  - Acceptance criteria section is repeated"
    end

    test "when a scenario is repeated or empty", %{output: output} do
      assert output =~
               "[INVALID] empty_scenario.md (Empty Scenario Spec)\n  - Scenario is empty: Success"

      assert output =~
               "[INVALID] repeated_scenario.md (Repeated Scenario Spec)\n  - Scenario is repeated: Success"
    end

    test "when a test is repeated", %{output: output} do
      assert output =~ "  - Test is repeated: Can be parsed - Scenario: Success"
    end
  end

  describe "Pending specs warning" do
    test "with reason: missing test file", %{output: output} do
      assert output =~
               """
               \e[33m[PENDING] pending.md (Pending Spec)
                 reason: missing test file
                 expected: pending_test.exs\e[0m
               """
               |> String.trim()
    end

    test "with reason: untested acceptance criteria", %{output: output} do
      assert output =~
               """
               \e[33m[PENDING] untested_acceptance_criteria.md (Untested Acceptance Criteria)
                 reason: untested acceptance criteria
                 - This has no matching test

                 Scenario: Missing scenario coverage
                 - Also remains pending without a matching test

                 Scenario: Partially implemented scenario
                 - Remains pending without a matching test\e[0m
               """
               |> String.trim()
    end
  end

  describe "Failed test error" do
    test "starts the specs path and title followed by the error detail", %{output: output} do
      assert output =~
               """
                 \e[31m
               [FAILED] failed.md (Failed Spec)\e[0m
                 1) test Fails with an assertion error (SpecsRunner.Fixtures.FailedTest)
                    \e[1m\e[30mtest_fixtures/failed_test.exs:5\e[0m
                    \e[31mExpected truthy, got false\e[0m
                    \e[36mcode: \e[0massert false
                    \e[36mstacktrace:\e[0m
                      test_fixtures/failed_test.exs:6: (test)
               """
               |> String.trim()
    end
  end
end
