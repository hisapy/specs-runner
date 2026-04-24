defmodule SpecsRunner.CoreTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.{Core, Scenario, Spec, Test}

  describe "set_pending/2" do
    test "sets pending status for spec, scenario, and test" do
      assert %Spec{status: :pending, error: "missing test file"} =
               Core.set_pending(%Spec{}, "missing test file")

      assert %Scenario{status: :pending, error: "missing describe"} =
               Core.set_pending(%Scenario{}, "missing describe")

      assert %Test{status: :pending, error: "missing test case"} =
               Core.set_pending(%Test{}, "missing test case")
    end
  end

  describe "set_passed/1" do
    test "sets passed status and clears error for spec, scenario, and test" do
      assert %Spec{status: :passed, error: nil} = Core.set_passed(%Spec{error: "old"})
      assert %Scenario{status: :passed, error: nil} = Core.set_passed(%Scenario{error: "old"})
      assert %Test{status: :passed, error: nil} = Core.set_passed(%Test{error: "old"})
    end
  end

  describe "set_failed/2" do
    test "sets failed status for spec, scenario, and test" do
      assert %Spec{status: :failed, error: "assertion failed"} =
               Core.set_failed(%Spec{}, "assertion failed")

      assert %Scenario{status: :failed, error: "setup error"} =
               Core.set_failed(%Scenario{}, "setup error")

      assert %Test{status: :failed, error: "runtime error"} =
               Core.set_failed(%Test{}, "runtime error")
    end
  end
end
