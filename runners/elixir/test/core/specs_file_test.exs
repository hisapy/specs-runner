defmodule SpecsRunner.SpecsFileTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.SpecsFile

  describe "list/1" do
    test "returns {:ok, paths} with all .md files in the specs dir" do
      specs_dir = create_tmp_dir("specs-file-list")

      first = Path.join(specs_dir, "a.md")
      nested_dir = Path.join(specs_dir, "nested")
      nested = Path.join(nested_dir, "b.md")
      ignored = Path.join(specs_dir, "ignore.txt")

      File.mkdir_p!(nested_dir)
      File.write!(first, "# A")
      File.write!(nested, "# B")
      File.write!(ignored, "ignore")

      assert {:ok, paths} = SpecsFile.list(specs_dir)
      assert paths == [first, nested]
    end

    test "returns {:ok, []} when the specs dir is empty" do
      specs_dir = create_tmp_dir("specs-file-empty")

      assert {:ok, []} == SpecsFile.list(specs_dir)
    end

    test "returns paths sorted alphabetically" do
      specs_dir = create_tmp_dir("specs-file-sort")

      c_file = Path.join(specs_dir, "c.md")
      a_file = Path.join(specs_dir, "a.md")
      b_file = Path.join(specs_dir, "b.md")

      File.write!(c_file, "# C")
      File.write!(a_file, "# A")
      File.write!(b_file, "# B")

      assert {:ok, paths} = SpecsFile.list(specs_dir)
      assert paths == [a_file, b_file, c_file]
    end
  end

  describe "test_file_path/3" do
    test "mirrors the spec path under the tests dir with _test.exs extension" do
      specs_dir = "specs"
      tests_dir = "tests"

      assert "tests/pending_test.exs" ==
               SpecsFile.test_file_path("specs/pending.md", specs_dir, tests_dir)
    end

    test "preserves subdirectory structure" do
      specs_dir = "specs"
      tests_dir = "tests"

      assert "tests/feature/login_test.exs" ==
               SpecsFile.test_file_path("specs/feature/login.md", specs_dir, tests_dir)
    end
  end

  describe "exists?/1" do
    test "returns true when the file exists" do
      tmp_dir = create_tmp_dir("specs-file-exists")
      file_path = Path.join(tmp_dir, "exists.md")
      File.write!(file_path, "# Exists")

      assert SpecsFile.exists?(file_path)
    end

    test "returns false when the file does not exist" do
      tmp_dir = create_tmp_dir("specs-file-missing")
      missing_path = Path.join(tmp_dir, "missing.md")

      refute SpecsFile.exists?(missing_path)
    end
  end

  defp create_tmp_dir(prefix) do
    dir = Path.join(System.tmp_dir!(), "#{prefix}-#{System.unique_integer([:positive])}")
    File.mkdir_p!(dir)
    on_exit(fn -> File.rm_rf(dir) end)
    dir
  end
end
