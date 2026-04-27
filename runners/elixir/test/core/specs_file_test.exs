defmodule SpecsRunner.SpecsFileTest do
  @moduledoc false
  use ExUnit.Case, async: true

  describe "list/1" do
    test "returns {:ok, paths} with all .md files in the specs dir"

    test "returns {:ok, []} when the specs dir is empty"

    test "returns paths sorted alphabetically"
  end

  describe "test_file_path/3" do
    test "mirrors the spec path under the tests dir with _test.exs extension"

    test "preserves subdirectory structure"
  end

  describe "exists?/1" do
    test "returns true when the file exists"

    test "returns false when the file does not exist"
  end
end
