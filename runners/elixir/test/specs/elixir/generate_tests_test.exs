defmodule SpecsRunner.GenerateTestsTest do
  @moduledoc false
  use ExUnit.Case, async: false

  @fixtures_dir Path.expand("../../../../../specs/fixtures_gen_tests", __DIR__)
  @snapshots_dir Path.expand("../../../test_fixtures", __DIR__)

  setup do
    tmp_dir =
      Path.join(
        System.tmp_dir!(),
        "specs_runner_generate_tests_#{System.unique_integer([:positive])}"
      )

    specs_dir = Path.join(tmp_dir, "specs")
    tests_dir = Path.join(tmp_dir, "tests")

    File.mkdir_p!(specs_dir)
    File.mkdir_p!(tests_dir)

    on_exit(fn -> File.rm_rf!(tmp_dir) end)

    [specs_dir: specs_dir, tests_dir: tests_dir]
  end

  describe "Missing test file" do
    test "generates a test file mirroring the specs structure with a describe block per scenario and a test block per acceptance criteria item",
         %{specs_dir: specs_dir, tests_dir: tests_dir} do
      copy_fixture_spec!(specs_dir, "generate_tests_with_scenarios.md")

      run_generate_tests(
        Path.join(specs_dir, "generate_tests_with_scenarios.md"),
        specs_dir,
        tests_dir
      )

      generated_path = Path.join(tests_dir, "generate_tests_with_scenarios_test.exs")

      assert File.exists?(generated_path)

      assert File.read!(generated_path) ==
               snapshot_content("generate_tests_with_scenarios_test.exs")
    end

    test "generates a test file with a bare test block per acceptance criteria item when the spec has no scenarios",
         %{specs_dir: specs_dir, tests_dir: tests_dir} do
      copy_fixture_spec!(specs_dir, "spec_without_scenarios.md")

      run_generate_tests(
        Path.join(specs_dir, "spec_without_scenarios.md"),
        specs_dir,
        tests_dir
      )

      generated_path = Path.join(tests_dir, "spec_without_scenarios_test.exs")

      assert File.exists?(generated_path)
      assert File.read!(generated_path) == snapshot_content("spec_without_scenarios_test.exs")
    end
  end

  describe "Missing test blocks" do
    test "adds missing describe and test blocks while preserving existing tests",
         %{specs_dir: specs_dir, tests_dir: tests_dir} do
      copy_fixture_spec!(specs_dir, "generate_tests_missing_blocks.md")

      copy_existing_test!(
        tests_dir,
        "generate_tests_missing_blocks_input_test.exs",
        "generate_tests_missing_blocks_test.exs"
      )

      run_generate_tests(
        Path.join(specs_dir, "generate_tests_missing_blocks.md"),
        specs_dir,
        tests_dir
      )

      generated_path = Path.join(tests_dir, "generate_tests_missing_blocks_test.exs")

      assert File.read!(generated_path) ==
               snapshot_content("generate_tests_missing_blocks_snapshot_test.exs")
    end
  end

  defp copy_fixture_spec!(specs_dir, fixture_name) do
    File.cp!(
      Path.join(@fixtures_dir, fixture_name),
      Path.join(specs_dir, fixture_name)
    )
  end

  defp copy_existing_test!(tests_dir, snapshot_name, test_path) do
    dest = Path.join(tests_dir, test_path)
    File.mkdir_p!(Path.dirname(dest))
    File.cp!(Path.join(@snapshots_dir, snapshot_name), dest)
  end

  defp snapshot_content(snapshot_name) do
    File.read!(Path.join(@snapshots_dir, snapshot_name))
  end

  defp run_generate_tests(spec_path, specs_dir, tests_dir) do
    Mix.Task.reenable("specs.generate_tests")

    Mix.Task.run("specs.generate_tests", [
      spec_path,
      "--specs-dir",
      specs_dir,
      "--tests-dir",
      tests_dir
    ])
  end
end
