defmodule SpecsRunner.OutputFormatterTest do
  use ExUnit.Case, async: true

  alias SpecsRunner.Core.RunInfo
  alias SpecsRunner.OutputFormatter

  test "execution can be set and retrieved" do
    {:ok, pid} = GenServer.start_link(OutputFormatter, [])

    run_info = RunInfo.new("specs", "tests")

    assert :ok = GenServer.call(pid, {:set_execution, run_info})
    assert run_info == GenServer.call(pid, :get_execution)
  end

  test "test_finished updates execution with passing test" do
    {:ok, pid} = GenServer.start_link(OutputFormatter, [])

    test_key = {"specs/my_spec.md", "Scenario", "passes"}

    run_info =
      RunInfo.new("specs", "tests")
      |> RunInfo.add_spec("specs/my_spec.md")
      |> RunInfo.add_test(test_key)

    assert :ok = GenServer.call(pid, {:set_execution, run_info})

    test = %ExUnit.Test{
      name: :"test passes",
      state: nil,
      tags: %{describe: "Scenario", file: "tests/my_spec_test.exs"}
    }

    assert :ok = GenServer.cast(pid, {:test_finished, test})

    updated_run_info = GenServer.call(pid, :get_execution)

    assert :passed == updated_run_info.tests[test_key].status
  end
end
