defmodule SpecsRunner.GenerateTestsTest do
  @moduledoc false
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  setup [:specs_and_tests_tmp_dirs]

  describe "With a missing test file" do
    test "creates the test file in the configured test directory", %{
      specs_dir: specs_dir,
      tests_dir: tests_dir
    } do
      copy_fixture_spec_to_tmp_dir!(specs_dir, "generate_tests_with_scenarios.md")
      expected_path = Path.join(tests_dir, "generate_tests_with_scenarios_test.exs")

      refute File.exists?(expected_path)

      run_generate_tests(
        Path.join(specs_dir, "generate_tests_with_scenarios.md"),
        specs_dir,
        tests_dir
      )

      assert File.exists?(expected_path)
    end

    test "generates tests and describe blocks matching the acceptance criteria ordering", %{
      specs_dir: specs_dir,
      tests_dir: tests_dir
    } do
      copy_fixture_spec_to_tmp_dir!(specs_dir, "generate_tests_with_scenarios.md")

      run_generate_tests(
        Path.join(specs_dir, "generate_tests_with_scenarios.md"),
        specs_dir,
        tests_dir
      )

      generated_path = Path.join(tests_dir, "generate_tests_with_scenarios_test.exs")

      assert File.read!(generated_path) ==
               snapshot_content("generate_tests_with_scenarios_test.exs")
    end
  end

  describe "When the test file exists" do
    setup %{tests_dir: tests_dir} do
      copy_existing_test!(
        tests_dir,
        "generate_tests_missing_blocks_input_test.exs",
        "generate_tests_missing_blocks_test.exs"
      )

      :ok
    end

    test "appends describe blocks to the test module", %{
      specs_dir: specs_dir,
      tests_dir: tests_dir
    } do
      copy_fixture_spec_to_tmp_dir!(specs_dir, "generate_tests_missing_blocks.md")

      generated_path = Path.join(tests_dir, "generate_tests_missing_blocks_test.exs")

      expected_snippet = """
        describe "Missing scenario coverage" do
          test "Also remains pending without a matching test"
        end
      """

      refute File.read!(generated_path) =~ expected_snippet

      run_generate_tests(
        Path.join(specs_dir, "generate_tests_missing_blocks.md"),
        specs_dir,
        tests_dir
      )

      assert File.read!(generated_path) =~ expected_snippet
    end

    test "appends tests to the test module", %{specs_dir: specs_dir, tests_dir: tests_dir} do
      copy_fixture_spec_to_tmp_dir!(specs_dir, "generate_tests_missing_blocks.md")

      generated_path = Path.join(tests_dir, "generate_tests_missing_blocks_test.exs")
      expected_snippet = ~s(  test "This has no matching test"\n)

      refute File.read!(generated_path) =~ expected_snippet

      run_generate_tests(
        Path.join(specs_dir, "generate_tests_missing_blocks.md"),
        specs_dir,
        tests_dir
      )

      assert File.read!(generated_path) =~ expected_snippet
    end

    test "appends tests to existing describe blocks", %{
      specs_dir: specs_dir,
      tests_dir: tests_dir
    } do
      copy_fixture_spec_to_tmp_dir!(specs_dir, "generate_tests_missing_blocks.md")

      generated_path = Path.join(tests_dir, "generate_tests_missing_blocks_test.exs")

      expected_snippet = """
        describe "Partially implemented scenario" do
          test "Has a matching test" do
            assert true
          end

          test "Remains pending without a matching test"
        end
      """

      refute File.read!(generated_path) =~ expected_snippet

      run_generate_tests(
        Path.join(specs_dir, "generate_tests_missing_blocks.md"),
        specs_dir,
        tests_dir
      )

      assert File.read!(generated_path) =~ expected_snippet
    end
  end

  @fixtures_dir Path.expand("../../../../../specs/fixtures_gen_tests", __DIR__)
  @snapshots_dir Path.expand("../../../test_fixtures", __DIR__)

  defp specs_and_tests_tmp_dirs(_) do
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

  defp copy_fixture_spec_to_tmp_dir!(specs_dir, fixture_name) do
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

    capture_io(fn ->
      Mix.Task.run("specs.generate_tests", [
        spec_path,
        "--specs-dir",
        specs_dir,
        "--tests-dir",
        tests_dir
      ])
    end)
  end
end
