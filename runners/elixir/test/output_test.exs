defmodule SpecsRunner.OutputTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.Core.RunInfo
  alias SpecsRunner.Core.Spec

  describe "run_started" do
    test "prints the specs run start message" do
      run_info = SpecsRunner.Core.RunInfo.new("specs/", "test/specs/")

      output =
        ExUnit.CaptureIO.capture_io(fn ->
          SpecsRunner.Output.run_started(run_info)
        end)

      expected_output_excerpt = """
      Specs Runner started
      Specs directory: specs/
      Tests directory: test/specs/
      """

      assert output =~ String.trim(expected_output_excerpt)
    end
  end

  describe "test_finished" do
    test "prints the matching spec title and failure details for failed tests" do
      spec = %Spec{
        Spec.new("specs/elixir/run_specs.md", "Run Specs")
        | path: "elixir/run_specs.md",
          test_file_path: "elixir/run_specs_test.exs"
      }

      run_info =
        RunInfo.new("specs", "test/specs")
        |> RunInfo.add_spec(spec)

      test = %ExUnit.Test{
        name: :"test reports the spec as pending",
        module: SpecsRunner.Specs.RunTest,
        parameters: %{},
        state: {:failed, [{:error, RuntimeError.exception("boom"), []}]},
        tags: %{file: ~c"test/specs/elixir/run_specs_test.exs"}
      }

      output =
        ExUnit.CaptureIO.capture_io(fn ->
          SpecsRunner.Output.test_finished(test, run_info)
        end)

      assert output =~ "elixir/run_specs.md (Run Specs)"
      assert output =~ "test reports the spec as pending (SpecsRunner.Specs.RunTest)"
      assert output =~ "** (RuntimeError) boom"
    end
  end

  # describe "spec_file_added" do
  #   @tag :skip
  #   test "adds the spec file to run state" do
  #     :ok
  #   end

  #   @tag :skip
  #   test "tracks the file as pending parsing" do
  #     :ok
  #   end
  # end

  # describe "spec_file_error" do
  #   @tag :skip
  #   test "records a parsing error for the spec file" do
  #     :ok
  #   end

  #   @tag :skip
  #   test "marks the spec file as failed" do
  #     :ok
  #   end
  # end

  # describe "spec_file_parsed" do
  #   @tag :skip
  #   test "marks the spec file as parsed" do
  #     :ok
  #   end

  #   @tag :skip
  #   test "does not clear previously collected errors" do
  #     :ok
  #   end
  # end
end
