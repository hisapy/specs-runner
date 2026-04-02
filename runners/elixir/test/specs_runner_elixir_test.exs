defmodule SpecsRunnerElixirTest do
  use ExUnit.Case

  test "module loads" do
    assert Code.ensure_loaded?(SpecsRunnerElixir)
  end
end
