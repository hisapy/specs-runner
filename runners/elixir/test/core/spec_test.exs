defmodule SpecsRunner.Core.SpecTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.Core.{Scenario, Spec, Test}

  describe "add_test/2" do
    test "adds a test to spec tests keyed by name" do
      spec = Spec.new("My Spec", "specs/my_spec.md")
      test = %Test{name: "test A"}

      spec = Spec.add_test(spec, test)

      assert spec.tests[test.name] == test
    end
  end

  describe "add_scenario/2" do
    test "adds a scenario to spec scenarios keyed by title" do
      spec = Spec.new("My Spec", "specs/my_spec.md")
      scenario = %Scenario{title: "Scenario A"}

      spec = Spec.add_scenario(spec, scenario)

      assert spec.scenarios[scenario.title] == scenario
    end
  end
end
