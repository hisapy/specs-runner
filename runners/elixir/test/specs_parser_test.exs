defmodule SpecsRunner.SpecsParserTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.SpecsParser
  alias SpecsRunner.Core.RunInfo

  @specs_dir Application.compile_env(:specs_runner, :specs_dir)
  @tests_dir Application.compile_env(:specs_runner, :tests_dir)

  setup do
    run_info = RunInfo.new(@specs_dir, @tests_dir)

    %{run_info: run_info}
  end

  describe "parse_file_stream!/2" do
    test "parse title", %{run_info: run_info} do
      spec_file_path = Path.join(@specs_dir, "pending.md")

      run_info = SpecsParser.parse_file_stream!(spec_file_path, run_info)

      assert run_info.specs[spec_file_path].title == "Pending Spec"
    end

    test "parse acceptance criteria into tests", %{run_info: run_info} do
      spec_file_path = Path.join(@specs_dir, "pending.md")

      run_info = SpecsParser.parse_file_stream!(spec_file_path, run_info)

      assert run_info.tests == %{
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

    test "parse acceptance criteria from scenarios into tests", %{run_info: run_info} do
      spec_file_path = Path.join(@specs_dir, "spec_with_scenarios.md")

      run_info = SpecsParser.parse_file_stream!(spec_file_path, run_info)

      assert run_info.tests == %{
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

    test "spec error when title is missing", %{run_info: run_info} do
      spec_file_path = Path.join(@specs_dir, "missing_title.md")

      run_info = SpecsParser.parse_file_stream!(spec_file_path, run_info)

      assert run_info.specs[spec_file_path].title == nil
      assert run_info.specs[spec_file_path].errors == ["Title not found in spec file"]
    end

    test "spec error when there is more than one h1 (# Title)", %{run_info: run_info} do
      spec_file_path = Path.join(@specs_dir, "repeated_title.md")

      run_info = SpecsParser.parse_file_stream!(spec_file_path, run_info)

      assert run_info.specs[spec_file_path].errors == ["Title is repeated"]
    end

    test "spec error when acceptance criteria section is missing", %{run_info: run_info} do
      spec_file_path = Path.join(@specs_dir, "missing_acceptance_criteria.md")

      run_info = SpecsParser.parse_file_stream!(spec_file_path, run_info)

      assert run_info.specs[spec_file_path].errors == ["Acceptance criteria section not found"]
    end

    test "spec error when acceptance criteria section is empty", %{run_info: run_info} do
      spec_file_path = Path.join(@specs_dir, "empty_acceptance_criteria.md")

      run_info = SpecsParser.parse_file_stream!(spec_file_path, run_info)

      assert run_info.specs[spec_file_path].errors == ["Acceptance criteria section is empty"]
    end

    test "spec error when acceptance criteria section is repeated", %{run_info: run_info} do
      spec_file_path = Path.join(@specs_dir, "repeated_acceptance_criteria.md")

      run_info = SpecsParser.parse_file_stream!(spec_file_path, run_info)

      assert run_info.specs[spec_file_path].errors == ["Acceptance criteria section is repeated"]
    end

    test "spec error when scenario is empty", %{run_info: run_info} do
      spec_file_path = Path.join(@specs_dir, "empty_scenario.md")

      run_info = SpecsParser.parse_file_stream!(spec_file_path, run_info)

      assert run_info.specs[spec_file_path].errors == ["Scenario is empty: Success"]
    end

    test "spec error when scenario is repeated", %{run_info: run_info} do
      spec_file_path = Path.join(@specs_dir, "repeated_scenario.md")

      run_info = SpecsParser.parse_file_stream!(spec_file_path, run_info)

      assert run_info.specs[spec_file_path].errors == ["Scenario is repeated: Success"]
    end
  end
end
