defmodule SpecsRunner.Fixtures.FailedTest do
  @moduledoc false
  use ExUnit.Case, async: true

  test "Fails with an assertion error" do
    assert false
  end
end
