defmodule SpecsRunnerTest do
  @moduledoc false
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  @specs_dir Application.compile_env(:specs_runner, :specs_dir)
  @tests_dir Application.compile_env(:specs_runner, :tests_dir)

  describe "run(specs_dir, tests_dir)" do
    # Uses empty dirs instead of the shared fixtures: ExUnit runs each test
    # module only once per VM, so running the fixtures here would leave
    # nothing for SpecsRunner.RunSpecsTest when this test runs first.
    @tag :tmp_dir
    test "returns {:ok, result} when completed successfully", %{tmp_dir: tmp_dir} do
      specs_dir = Path.join(tmp_dir, "specs")
      tests_dir = Path.join(tmp_dir, "tests")
      File.mkdir_p!(specs_dir)
      File.mkdir_p!(tests_dir)

      {{:ok, result}, _output} =
        with_io(fn ->
          SpecsRunner.run(specs_dir, tests_dir)
        end)

      assert result.specs_dir == Path.expand(specs_dir)
      assert result.tests_dir == Path.expand(tests_dir)

      assert DateTime.compare(result.start_time, result.end_time) in [:lt, :eq]

      assert is_map(result.specs)
    end

    test "returns {:error, reason} when the specs_dir is not found" do
      specs_dir = "invalid/specs/dir"
      reason = "#{specs_dir}: Directory not found"

      assert SpecsRunner.run(specs_dir, @tests_dir) == {:error, reason}
    end

    test "returns {:error, reason} when the tests_dir is not found" do
      tests_dir = "invalid/tests/dir"
      reason = "#{tests_dir}: Directory not found"

      assert SpecsRunner.run(@specs_dir, tests_dir) == {:error, reason}
    end
  end
end
