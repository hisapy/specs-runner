defmodule SpecsRunnerTest do
  use ExUnit.Case
  doctest SpecsRunner

  test "greets the world" do
    assert SpecsRunner.hello() == :world
  end
end
