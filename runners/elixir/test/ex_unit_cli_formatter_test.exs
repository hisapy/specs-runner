defmodule SpecsRunner.ExUnitCLIFormatterTest do
  @moduledoc false
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias SpecsRunner.Core.{RunInfo, Spec, Test}

  describe "handle_cast/2 :test_finished passed" do
    setup do
      spec =
        %Spec{
          path: "elixir/run_specs.md",
          test_file_path: "elixir/run_specs_test.exs",
          title: "Run Specs"
        }
        |> Spec.add_test!(%Test{
          scenario_name: "Missing test file",
          name: "reports the spec as pending"
        })

      run_info =
        RunInfo.new("specs", "test/specs")
        |> RunInfo.add_spec(spec)

      {:ok, formatter} =
        GenServer.start_link(SpecsRunner.ExUnitCLIFormatter, run_info: run_info, colors: [])

      {:ok, run_info: run_info, formatter: formatter}
    end

    test "updates the matching test status", %{formatter: formatter} do
      ex_unit_test = %ExUnit.Test{
        name: :"test reports the spec as pending",
        module: SpecsRunner.Specs.RunTest,
        parameters: %{},
        state: nil,
        tags: %{
          file: ~c"test/specs/elixir/run_specs_test.exs",
          describe: "Missing test file",
          test_type: :test
        }
      }

      {%{run_info: run_info}, _output} =
        with_io(formatter, fn ->
          GenServer.cast(formatter, {:test_finished, ex_unit_test})

          :sys.get_state(formatter)
        end)

      assert %{tests: tests} = RunInfo.fetch_spec!(run_info, "elixir/run_specs_test.exs")
      assert %{status: :passed} = tests[{"Missing test file", "reports the spec as pending"}]
    end

    # test "prints a green dot"
    # test "prints warning if test is not found in run_info.specs"
  end
end
