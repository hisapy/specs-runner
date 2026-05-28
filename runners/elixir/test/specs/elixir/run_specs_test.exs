defmodule SpecsRunner.Specs.RunTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  describe "Invalid specs error" do
    setup do
      [
        output:
          capture_io(fn ->
            # The specs dir and tests dir are configured in config/test.exs
            Mix.Task.reenable("specs.run")
            Mix.Task.run("specs.run", [])
          end)
      ]
    end

    test "includes the specs file path", %{output: output} do
      assert output =~ "[INVALID] missing_title.md"
    end

    test "includes the title when present", %{output: output} do
      assert output =~ "[INVALID] repeated_title.md (Repeated Title Spec)"
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
end
