defmodule SpecsRunner.ExUnitCLIFormatterTest do
  @moduledoc false
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias SpecsRunner.ExUnitCLIFormatter
  alias SpecsRunner.Core.{RunInfo, Spec, Test}

  describe "handle_cast/2 :test_finished passed" do
    @describetag ex_unit_test_state: :passed

    setup [
      :run_info_with_one_spec,
      :formatter,
      :ex_unit_test,
      :cast_test_finished_with_io
    ]

    test "updates the matching test status to passed", %{
      run_info: run_info,
      scenario_name: scenario_name,
      test_name: test_name
    } do
      [spec | _] = run_info.specs |> Map.values()

      assert %{status: :passed} = spec.tests[{scenario_name, test_name}]
    end

    test "prints a green dot", %{output: output} do
      assert output =~ ExUnitCLIFormatter.colorize(:success, ".")
    end
  end

  describe "handle_cast/2 :test_finished failed" do
    @describetag ex_unit_test_state: :failed

    setup [
      :run_info_with_one_spec,
      :formatter,
      :ex_unit_test,
      :cast_test_finished_with_io
    ]

    test "updates the matching test status to failed", %{
      run_info: run_info,
      scenario_name: scenario_name,
      test_name: test_name
    } do
      [spec | _] = run_info.specs |> Map.values()

      assert %{status: :failed} = spec.tests[{scenario_name, test_name}]
    end

    test "prints [FAILED] spec/file/path (Spec Title)", %{output: output} do
      assert output =~
               ExUnitCLIFormatter.colorize(:failure, "\n[FAILED] elixir/run_specs.md (Run Specs)")
    end

    test "prints test errors like ExUnit does", %{output: output} do
      colors = %{
        colors: [
          enabled: true,
          failure: :red,
          location_info: [:bright, :black],
          extra_info: :cyan
        ]
      }

      assert output =~
               ExUnitCLIFormatter.colorize(
                 :failure,
                 "\n[FAILED] elixir/run_specs.md (Run Specs)",
                 colors
               ) <>
                 "\n  1) test Missing test file reports the spec as pending (SpecsRunner.Specs.RunTest)\n     " <>
                 ExUnitCLIFormatter.colorize(
                   :location_info,
                   "test/specs/elixir/run_specs_test.exs:",
                   colors
                 ) <>
                 "\n     " <>
                 ExUnitCLIFormatter.colorize(
                   :failure,
                   "expected false to be truthy",
                   colors
                 ) <>
                 "\n     " <>
                 ExUnitCLIFormatter.colorize(:extra_info, "left: ", colors) <>
                 "false\n\n"
    end
  end

  describe "handle_cast/2 :test_finished invalid" do
    @describetag ex_unit_test_state: :invalid

    setup [
      :run_info_with_one_spec,
      :formatter,
      :ex_unit_test,
      :cast_test_finished_with_io
    ]

    test "updates the matching test status to failed", %{
      run_info: run_info,
      scenario_name: scenario_name,
      test_name: test_name
    } do
      [spec | _] = run_info.specs |> Map.values()

      assert %{status: :failed} = spec.tests[{scenario_name, test_name}]
    end

    test "prints [FAILED] spec/file/path (Spec Title)", %{output: output} do
      assert output =~
               ExUnitCLIFormatter.colorize(:failure, "\n[FAILED] elixir/run_specs.md (Run Specs)")
    end

    test "prints the invalid test message", %{output: output} do
      assert output =~
               ExUnitCLIFormatter.colorize(:invalid, "?", %{
                 colors: [enabled: true, invalid: :yellow]
               })
    end
  end

  ## Test setup helpers

  defp run_info_with_one_spec(_context) do
    run_info = RunInfo.new("specs", "test/specs")

    test = %Test{
      scenario_name: "Missing test file",
      name: "reports the spec as pending"
    }

    spec =
      Spec.add_test!(
        %Spec{
          path: "elixir/run_specs.md",
          test_path: "elixir/run_specs_test.exs",
          title: "Run Specs"
        },
        test
      )

    [
      run_info: RunInfo.add_spec(run_info, spec),
      scenario_name: test.scenario_name,
      test_name: test.name
    ]
  end

  defp formatter(%{run_info: run_info}) do
    {:ok, formatter} =
      GenServer.start_link(ExUnitCLIFormatter,
        run_info: run_info,
        colors: [enabled: true]
      )

    [formatter: formatter]
  end

  defp ex_unit_test(%{ex_unit_test_state: :passed} = context) do
    ex_unit_test = build_ex_unit_test(context, nil)

    [ex_unit_test: ex_unit_test]
  end

  defp ex_unit_test(%{ex_unit_test_state: :failed} = context) do
    ex_unit_test =
      build_ex_unit_test(
        context,
        {:failed,
         [
           {:error, %ExUnit.AssertionError{message: "expected false to be truthy", left: false},
            []}
         ]}
      )

    [ex_unit_test: ex_unit_test]
  end

  defp ex_unit_test(%{ex_unit_test_state: :invalid} = context) do
    ex_unit_test =
      build_ex_unit_test(
        context,
        {:invalid,
         %ExUnit.TestModule{
           name: SpecsRunner.Specs.RunTest,
           file: ~c"test/specs/elixir/run_specs_test.exs",
           state:
             {:failed,
              [
                {:error,
                 %ExUnit.AssertionError{message: "expected false to be truthy", left: false}, []}
              ]}
         }}
      )

    [ex_unit_test: ex_unit_test]
  end

  defp build_ex_unit_test(%{scenario_name: scenario_name, test_name: test_name}, state) do
    ex_unit_test = %ExUnit.Test{
      name: String.to_atom("test #{scenario_name} #{test_name}"),
      module: SpecsRunner.Specs.RunTest,
      parameters: %{},
      state: state,
      tags: %{
        file: ~c"test/specs/elixir/run_specs_test.exs",
        describe: scenario_name,
        test_type: :test
      }
    }

    ex_unit_test
  end

  defp cast_test_finished_with_io(%{formatter: formatter, ex_unit_test: ex_unit_test}) do
    {run_info, output} =
      with_io(formatter, fn ->
        GenServer.cast(formatter, {:test_finished, ex_unit_test})

        :sys.get_state(formatter)[:run_info]
      end)

    [run_info: run_info, output: output]
  end
end
