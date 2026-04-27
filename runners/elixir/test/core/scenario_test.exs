defmodule SpecsRunner.Core.ScenarioTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.Core.{Scenario, Test}

  describe "add_test/2" do
    test "adds a test to scenario tests keyed by name" do
      scenario = Scenario.new("Scenario A")
      test = %Test{name: "test A"}

      scenario = Scenario.add_test(scenario, test)

      assert scenario.tests[test.name] == test
    end
  end
end
