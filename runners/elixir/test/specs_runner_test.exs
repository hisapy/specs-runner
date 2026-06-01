defmodule SpecsRunnerTest do
  @moduledoc false
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  @specs_dir Application.compile_env(:specs_runner, :specs_dir)
  @tests_dir Application.compile_env(:specs_runner, :tests_dir)

  describe "run(specs_dir, tests_dir)" do
    test "returns {:ok, result} when completed successfully" do
      {{:ok, result}, _output} =
        with_io(fn ->
          SpecsRunner.run(@specs_dir, @tests_dir)
        end)

      assert result.specs_dir == Path.expand(@specs_dir)
      assert result.tests_dir == Path.expand(@tests_dir)

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
