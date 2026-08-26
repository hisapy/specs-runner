defmodule SpecsRunner.TestFileUpdaterTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.TestFileUpdater

  setup do
    tmp_dir =
      Path.join(System.tmp_dir!(), "test_file_updater_#{System.unique_integer([:positive])}")

    File.mkdir_p!(tmp_dir)
    on_exit(fn -> File.rm_rf!(tmp_dir) end)

    [tmp_dir: tmp_dir]
  end

  describe "update!/2" do
    test "adds a bare test, appends a test to an existing describe, and adds a missing describe block, while preserving existing tests",
         %{tmp_dir: tmp_dir} do
      test_path = Path.join(tmp_dir, "generate_tests_missing_blocks_test.exs")

      File.write!(test_path, """
      defmodule SpecsRunner.GenerateTestsMissingBlocksTest do
        @moduledoc false
        use ExUnit.Case, async: true

        describe "Partially implemented scenario" do
          test "Has a matching test" do
            assert true
          end
        end
      end
      """)

      outline = [
        %{scenario_name: nil, tests: ["This has no matching test"]},
        %{
          scenario_name: "Partially implemented scenario",
          tests: ["Has a matching test", "Remains pending without a matching test"]
        },
        %{
          scenario_name: "Missing scenario coverage",
          tests: ["Also remains pending without a matching test"]
        }
      ]

      TestFileUpdater.update!(test_path, outline)

      assert File.read!(test_path) == """
             defmodule SpecsRunner.GenerateTestsMissingBlocksTest do
               @moduledoc false
               use ExUnit.Case, async: true

               test "This has no matching test"

               describe "Partially implemented scenario" do
                 test "Has a matching test" do
                   assert true
                 end

                 test "Remains pending without a matching test"
               end

               describe "Missing scenario coverage" do
                 test "Also remains pending without a matching test"
               end
             end
             """
    end

    test "leaves the file untouched when every describe and test already exists", %{
      tmp_dir: tmp_dir
    } do
      test_path = Path.join(tmp_dir, "already_covered_test.exs")

      original = """
      defmodule SpecsRunner.AlreadyCoveredTest do
        @moduledoc false
        use ExUnit.Case, async: true

        test "Works" do
          assert true
        end
      end
      """

      File.write!(test_path, original)

      outline = [%{scenario_name: nil, tests: ["Works"]}]

      TestFileUpdater.update!(test_path, outline)

      assert File.read!(test_path) == original
    end
  end
end
