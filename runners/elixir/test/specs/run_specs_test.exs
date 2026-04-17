defmodule SpecsRunner.Specs.RunTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  describe "Missing test file" do
    test "reports the spec as pending" do
      specs_dir = Path.expand("../fixtures/specs", __DIR__)
      tests_dir = Path.expand("../fixtures/test_specs", __DIR__)

      output =
        capture_io(fn ->
          Mix.Task.reenable("specs.run")
          Mix.Task.run("specs.run", ["--specs-dir", specs_dir, "--tests-dir", tests_dir])
        end)

      assert output =~ ~r/\[pending\]\s+Pending Spec/
    end

    test "shows the name of the missing test file"
  end
end
