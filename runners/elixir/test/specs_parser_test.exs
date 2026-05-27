defmodule SpecsRunner.SpecsParserTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SpecsRunner.SpecsParser

  @specs_dir Application.compile_env(:specs_runner, :specs_dir)
  @tests_dir Application.compile_env(:specs_runner, :tests_dir)

  describe "parse_file_stream!/3" do
    test "parse title" do
      spec_file_path = Path.join(@specs_dir, "pending.md")

      spec = SpecsParser.parse_file_stream!(spec_file_path, @specs_dir, @tests_dir)

      assert spec.title == "Pending Spec"
    end

    test "parse acceptance criteria into tests" do
      spec_file_path = Path.join(@specs_dir, "pending.md")

      spec = SpecsParser.parse_file_stream!(spec_file_path, @specs_dir, @tests_dir)

      assert spec.tests == %{
               {nil, "Reports as pending when the matching test file is missing"} =>
                 %SpecsRunner.Core.Test{
                   name: "Reports as pending when the matching test file is missing",
                   scenario_name: nil,
                   status: :pending,
                   errors: nil
                 },
               {nil, "Can be parsed"} => %SpecsRunner.Core.Test{
                 name: "Can be parsed",
                 scenario_name: nil,
                 status: :pending,
                 errors: nil
               }
             }
    end

    test "parse acceptance criteria from scenarios into tests" do
      spec_file_path = Path.join(@specs_dir, "spec_with_scenarios.md")

      spec = SpecsParser.parse_file_stream!(spec_file_path, @specs_dir, @tests_dir)

      assert spec.tests == %{
               {"Success", "Can be parsed"} => %SpecsRunner.Core.Test{
                 name: "Can be parsed",
                 scenario_name: "Success",
                 status: :pending,
                 errors: nil
               },
               {"Failure", "Can be parsed"} => %SpecsRunner.Core.Test{
                 name: "Can be parsed",
                 scenario_name: "Failure",
                 status: :pending,
                 errors: nil
               }
             }
    end

    test "spec error when title is missing" do
      spec_file_path = Path.join(@specs_dir, "missing_title.md")

      spec = SpecsParser.parse_file_stream!(spec_file_path, @specs_dir, @tests_dir)

      assert spec.title == nil
      assert spec.errors == ["Title not found in spec file"]
    end

    test "spec error when there is more than one h1 (# Title)" do
      spec_file_path = Path.join(@specs_dir, "repeated_title.md")

      spec = SpecsParser.parse_file_stream!(spec_file_path, @specs_dir, @tests_dir)

      assert spec.errors == ["Title is repeated"]
    end

    test "spec error when acceptance criteria section is missing" do
      spec_file_path = Path.join(@specs_dir, "missing_acceptance_criteria.md")

      spec = SpecsParser.parse_file_stream!(spec_file_path, @specs_dir, @tests_dir)

      assert spec.errors == ["Acceptance criteria section not found"]
    end

    test "spec error when acceptance criteria section is empty" do
      spec_file_path = Path.join(@specs_dir, "empty_acceptance_criteria.md")

      spec = SpecsParser.parse_file_stream!(spec_file_path, @specs_dir, @tests_dir)

      assert spec.errors == ["Acceptance criteria section is empty"]
    end

    test "spec error when acceptance criteria section is repeated" do
      spec_file_path = Path.join(@specs_dir, "repeated_acceptance_criteria.md")

      spec = SpecsParser.parse_file_stream!(spec_file_path, @specs_dir, @tests_dir)

      assert spec.errors == ["Acceptance criteria section is repeated"]
    end

    test "spec error when scenario is empty" do
      spec_file_path = Path.join(@specs_dir, "empty_scenario.md")

      spec = SpecsParser.parse_file_stream!(spec_file_path, @specs_dir, @tests_dir)

      assert spec.errors == ["Scenario is empty: Success"]
    end

    test "spec error when scenario is repeated" do
      spec_file_path = Path.join(@specs_dir, "repeated_scenario.md")

      spec = SpecsParser.parse_file_stream!(spec_file_path, @specs_dir, @tests_dir)

      assert spec.errors == [
               "Scenario is repeated: Success",
               "Test is repeated: Can be parsed - Scenario: Success"
             ]
    end

    test "normalizes spec and test paths" do
      spec_file_path = Path.join(@specs_dir, "spec_with_scenarios.md")

      spec = SpecsParser.parse_file_stream!(spec_file_path, @specs_dir, @tests_dir)

      assert spec.path == "spec_with_scenarios.md"
      assert spec.test_path == "spec_with_scenarios_test.exs"
    end
  end
end
