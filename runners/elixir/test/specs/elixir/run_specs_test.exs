defmodule SpecsRunner.Specs.RunTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  # failed test example:
  #   %ExUnit.Test{
  #   name: :"test reports the spec as pending",
  #   case: SpecsRunner.Specs.RunTest,
  #   module: SpecsRunner.Specs.RunTest,
  #   state: {:failed,
  #    [
  #      {:error,
  #       %ExUnit.AssertionError{
  #         left: "",
  #         right: ~r/\[pending\]\s+Pending Spec/,
  #         message: "Assertion with =~ failed",
  #         expr: {:assert, [line: 14],
  #          [
  #            {:=~, [line: 14],
  #             [
  #               {:output, [line: 14], nil},
  #               {:sigil_r, [delimiter: "/", line: 14],
  #                [{:<<>>, [line: 14], ["\\[pending\\]\\s+Pending Spec"]}, []]}
  #             ]}
  #          ]},
  #         args: :ex_unit_no_meaningful_value,
  #         doctest: :ex_unit_no_meaningful_value,
  #         context: :==
  #       },
  #       [
  #         {SpecsRunner.Specs.RunTest, :"test reports the spec as pending", 1,
  #          [file: ~c"test/specs/run_specs_test.exs", line: 14]}
  #       ]}
  #    ]},
  #   time: 4413,
  #   tags: %{
  #     async: true,
  #     line: 7,
  #     module: SpecsRunner.Specs.RunTest,
  #     registered: %{},
  #     file: "/Users/hisa/workspace/specs-runner/runners/elixir/test/specs/run_specs_test.exs",
  #     test: :"test reports the spec as pending",
  #     describe_line: nil,
  #     test_type: :test,
  #     test_group: nil,
  #     describe: nil
  #   },
  #   logs: "",
  #   parameters: %{}
  # }

  # passed test example:
  # %ExUnit.Test{
  #   name: :"test run(specs_dir, tests_dir) returns {:ok, result} when completed successfully",
  #   case: SpecsRunnerTest,
  #   module: SpecsRunnerTest,
  #   state: nil,
  #   time: 1,
  #   tags: %{
  #     async: true,
  #     line: 9,
  #     module: SpecsRunnerTest,
  #     registered: %{},
  #     file: "/Users/hisa/workspace/specs-runner/runners/elixir/test/specs_runner_test.exs",
  #     test: :"test run(specs_dir, tests_dir) returns {:ok, result} when completed successfully",
  #     describe_line: 8,
  #     test_type: :test,
  #     test_group: nil,
  #     describe: "run(specs_dir, tests_dir)"
  #   },
  #   logs: "",
  #   parameters: %{}
  # }

  @pending_missing_test_file_excerpt "No test file for pending.md, expected: pending_test.exs"

  describe "Missing test file" do
    test "reports the spec as pending" do
      output =
        capture_io(fn ->
          Mix.Task.reenable("specs.run")
          Mix.Task.run("specs.run", [])
        end)

      refute output =~ @pending_missing_test_file_excerpt
    end

    test "shows the name of the missing test file" do
      output =
        capture_io(fn ->
          Mix.Task.reenable("specs.run")
          Mix.Task.run("specs.run", [])
        end)

      assert output =~ "pending_test.exs"
    end
  end
end
