defmodule SpecsRunnerTest do
  @moduledoc false
  alias Supervisor.Spec
  use ExUnit.Case, async: true

  @specs_dir Application.compile_env(:specs_runner, :specs_dir)
  @tests_dir Application.compile_env(:specs_runner, :tests_dir)

  describe "run(specs_dir, tests_dir)" do
    test "returns {:ok, result} when completed successfully" do
      assert {:ok, %SpecsRunner.Result{}} = SpecsRunner.run(@specs_dir, @tests_dir)
    end

    test "returns {:error, reason} when the specs_dir is not found" do
      assert SpecsRunner.run("invalid/specs/dir", @tests_dir) == {:error, :specs_dir_not_found}
    end

    test "returns error when the tests_dir is not found" do
      assert SpecsRunner.run(@specs_dir, "invalid/tests/dir") == {:error, :tests_dir_not_found}
    end
  end
end
