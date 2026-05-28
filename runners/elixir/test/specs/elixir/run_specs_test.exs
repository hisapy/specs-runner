defmodule SpecsRunner.Specs.RunTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  describe "Invalid specs error" do
    setup do
      [output: run_mix_task()]
    end

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
    setup do
      [output: run_mix_task()]
    end

    test "with reason: missing test file", %{output: output} do
      assert output =~ "[PENDING] pending.md (Pending Spec)"
      assert output =~ "reason: missing test file"
      assert output =~ "pending_test.exs"
    end

    test "with reason: missing scenario", %{output: output} do
      assert output =~ "[PENDING] missing_scenario.md (Missing Scenario)"
      assert output =~ "reason: missing scenario"
      assert output =~ "Scenario: Missing scenario"
    end

    test "with reason: untested acceptance criteria", %{output: output} do
      assert output =~ "[PENDING] untested_acceptance_criteria.md (Untested Acceptance Criteria)"
      assert output =~ "reason: untested acceptance criteria"
      assert output =~ "Remains pending without a matching test"
    end
  end

  defp run_mix_task do
    capture_io(fn ->
      # The specs dir and tests dir are configured in config/test.exs
      Mix.Task.reenable("specs.run")
      Mix.Task.run("specs.run", [])
    end)
  end
end
