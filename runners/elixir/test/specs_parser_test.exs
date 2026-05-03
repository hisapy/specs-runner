defmodule SpecsRunner.SpecsParserTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.SpecsParser
  alias SpecsRunner.Core.Run

  @specs_dir Application.compile_env(:specs_runner, :specs_dir)
  @tests_dir Application.compile_env(:specs_runner, :tests_dir)

  setup do
    run = Run.new(@specs_dir, @tests_dir)

    %{run: run}
  end

  describe "parse_file_stream!/2" do
    test "parse title", %{run: run} do
      spec_file_path = Path.join(@specs_dir, "pending.md")

      run = SpecsParser.parse_file_stream!(spec_file_path, run)

      assert run.specs[spec_file_path].title == "Pending Spec"
    end

    test "parse acceptance criteria into tests", %{run: run} do
      spec_file_path = Path.join(@specs_dir, "pending.md")

      run = SpecsParser.parse_file_stream!(spec_file_path, run)

      assert run.tests == %{
               {spec_file_path, nil, "Reports as pending when the matching test file is missing"} =>
                 %SpecsRunner.Core.Test{
                   status: :pending,
                   errors: nil
                 },
               {spec_file_path, nil, "Can be parsed"} => %SpecsRunner.Core.Test{
                 status: :pending,
                 errors: nil
               }
             }
    end

    test "parse acceptance criteria from scenarios into tests", %{run: run} do
      spec_file_path = Path.join(@specs_dir, "spec_with_scenarios.md")

      run = SpecsParser.parse_file_stream!(spec_file_path, run)

      assert run.tests == %{
               {spec_file_path, "Success", "Can be parsed"} => %SpecsRunner.Core.Test{
                 status: :pending,
                 errors: nil
               },
               {spec_file_path, "Failure", "Can be parsed"} => %SpecsRunner.Core.Test{
                 status: :pending,
                 errors: nil
               }
             }
    end

    test "spec error when title is missing", %{run: run} do
      spec_file_path = Path.join(@specs_dir, "missing_title.md")

      run = SpecsParser.parse_file_stream!(spec_file_path, run)

      assert run.specs[spec_file_path].title == nil
      assert run.specs[spec_file_path].errors == ["Title not found in spec file"]
    end

    test "spec error when title is repeated"
    test "spec error when acceptance criteria section is missing"
    test "spec error when acceptance criteria section is empty"
    test "spec error when scenario is empty"
    test "spec error when scenario is repeated"
  end
end
