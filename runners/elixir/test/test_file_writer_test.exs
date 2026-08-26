defmodule SpecsRunner.TestFileWriterTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.TestFileWriter

  setup do
    tmp_dir =
      Path.join(System.tmp_dir!(), "test_file_writer_#{System.unique_integer([:positive])}")

    File.mkdir_p!(tmp_dir)
    on_exit(fn -> File.rm_rf!(tmp_dir) end)

    [tmp_dir: tmp_dir]
  end

  describe "write!/3" do
    test "writes a module with a bare test per item when there are no scenarios", %{
      tmp_dir: tmp_dir
    } do
      test_path = Path.join(tmp_dir, "spec_without_scenarios_test.exs")

      outline = [
        %{scenario_name: nil, tests: ["Can be parsed", "Can be validated"]}
      ]

      TestFileWriter.write!(test_path, SpecsRunner.SpecWithoutScenariosTest, outline)

      assert File.read!(test_path) == """
             defmodule SpecsRunner.SpecWithoutScenariosTest do
               @moduledoc false
               use ExUnit.Case, async: true

               test "Can be parsed"
               test "Can be validated"
             end
             """
    end

    test "writes a describe block per scenario", %{tmp_dir: tmp_dir} do
      test_path = Path.join(tmp_dir, "generate_tests_with_scenarios_test.exs")

      outline = [
        %{scenario_name: "Success", tests: ["Can be parsed"]},
        %{scenario_name: "Failure", tests: ["Can be parsed"]}
      ]

      TestFileWriter.write!(test_path, SpecsRunner.GenerateTestsWithScenariosTest, outline)

      assert File.read!(test_path) == """
             defmodule SpecsRunner.GenerateTestsWithScenariosTest do
               @moduledoc false
               use ExUnit.Case, async: true

               describe "Success" do
                 test "Can be parsed"
               end

               describe "Failure" do
                 test "Can be parsed"
               end
             end
             """
    end

    test "creates parent directories when they don't exist", %{tmp_dir: tmp_dir} do
      test_path = Path.join(tmp_dir, "nested/dir/spec_test.exs")
      outline = [%{scenario_name: nil, tests: ["Works"]}]

      TestFileWriter.write!(test_path, SpecsRunner.Nested.Dir.SpecTest, outline)

      assert File.exists?(test_path)
    end
  end
end
