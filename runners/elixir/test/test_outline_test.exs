defmodule SpecsRunner.TestOutlineTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.Core.{Spec, Test}
  alias SpecsRunner.TestOutline

  describe "from_spec/1" do
    test "groups tests under a single nil-scenario group when the spec has no scenarios" do
      spec =
        %Spec{}
        |> Spec.add_test!(%Test{name: "Can be parsed", scenario_name: nil, position: 0})
        |> Spec.add_test!(%Test{name: "Can be validated", scenario_name: nil, position: 1})

      assert TestOutline.from_spec(spec) == [
               %{scenario_name: nil, tests: ["Can be parsed", "Can be validated"]}
             ]
    end

    test "groups tests by scenario, preserving scenario and test order" do
      spec =
        %Spec{}
        |> Spec.add_test!(%Test{name: "Can be parsed", scenario_name: "Success", position: 0})
        |> Spec.add_test!(%Test{name: "Can be parsed", scenario_name: "Failure", position: 1})

      assert TestOutline.from_spec(spec) == [
               %{scenario_name: "Success", tests: ["Can be parsed"]},
               %{scenario_name: "Failure", tests: ["Can be parsed"]}
             ]
    end

    test "keeps the flat (no-scenario) group ordered before scenario groups regardless of map order" do
      spec =
        %Spec{}
        |> Spec.add_test!(%Test{
          name: "Has a matching test",
          scenario_name: "Partially implemented scenario",
          position: 1
        })
        |> Spec.add_test!(%Test{
          name: "Remains pending without a matching test",
          scenario_name: "Partially implemented scenario",
          position: 2
        })
        |> Spec.add_test!(%Test{
          name: "Also remains pending without a matching test",
          scenario_name: "Missing scenario coverage",
          position: 3
        })
        |> Spec.add_test!(%Test{
          name: "This has no matching test",
          scenario_name: nil,
          position: 0
        })

      assert TestOutline.from_spec(spec) == [
               %{scenario_name: nil, tests: ["This has no matching test"]},
               %{
                 scenario_name: "Partially implemented scenario",
                 tests: ["Has a matching test", "Remains pending without a matching test"]
               },
               %{
                 scenario_name: "Missing scenario coverage",
                 tests: ["Also remains pending without a matching test"]
               }
             ]
    end
  end
end
