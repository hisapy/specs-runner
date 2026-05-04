defmodule SpecsRunnerTest do
  @moduledoc false
  use ExUnit.Case, async: true

  @specs_dir Application.compile_env(:specs_runner, :specs_dir)
  @tests_dir Application.compile_env(:specs_runner, :tests_dir)

  describe "run(specs_dir, tests_dir)" do
    test "returns {:ok, result} when completed successfully" do
      {:ok, result} = SpecsRunner.run(@specs_dir, @tests_dir)

      assert result.specs_dir == @specs_dir
      assert result.tests_dir == @tests_dir

      assert DateTime.compare(result.start_time, result.end_time) in [:lt, :eq]

      assert is_map(result.tests)
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
