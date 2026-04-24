defmodule SpecsRunner.SpecTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.{Scenario, Spec, Test}

  describe "add_test/2" do
    test "adds a test to spec tests" do
      spec = %Spec{}
      test_case = %Test{title: "test A"}

      assert %Spec{tests: [%Test{title: "test A"}]} = Spec.add_test(spec, test_case)
    end
  end

  describe "add_scenario/2" do
    test "adds a scenario to spec scenarios" do
      spec = %Spec{}
      scenario = %Scenario{title: "Scenario A"}

      assert %Spec{scenarios: [%Scenario{title: "Scenario A"}]} =
               Spec.add_scenario(spec, scenario)
    end
  end
end
