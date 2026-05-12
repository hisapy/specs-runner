defmodule SpecsRunner.OutputTest do
  @moduledoc false
  use ExUnit.Case, async: true

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
