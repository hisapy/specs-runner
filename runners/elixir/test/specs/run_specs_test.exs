defmodule SpecsRunner.Specs.RunTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  describe "Missing test file" do
    test "reports the spec as pending" do
      output =
        capture_io(fn ->
          Mix.Task.reenable("specs.run")
          Mix.Task.run("specs.run", [])
        end)

      assert output =~ ~r/\[pending\]\s+Pending Spec/
    end

    test "shows the name of the missing test file"
  end
end
