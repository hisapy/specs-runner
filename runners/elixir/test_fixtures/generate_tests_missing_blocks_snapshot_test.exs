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
