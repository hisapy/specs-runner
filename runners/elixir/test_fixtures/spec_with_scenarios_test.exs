defmodule SpecsRunner.Fixtures.SpecWithScenariosTest do
  @moduledoc false
  use ExUnit.Case, async: true

  describe "Success" do
    test "Can be parsed" do
      assert true
    end
  end

  describe "Failure" do
    test "Can be parsed" do
      assert true
    end
  end
end
