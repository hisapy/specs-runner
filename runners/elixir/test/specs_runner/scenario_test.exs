defmodule SpecsRunner.ScenarioTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.{Scenario, Test}

  describe "add_test/2" do
    test "adds a test to scenario tests" do
      scenario = %Scenario{}
      test_case = %Test{title: "test A"}

      assert %Scenario{tests: [%Test{title: "test A"}]} = Scenario.add_test(scenario, test_case)
    end
  end
end
