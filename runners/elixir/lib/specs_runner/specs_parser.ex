defmodule SpecsRunner.SpecsParser do
  @moduledoc false

  alias SpecsRunner.Core.{Spec, Test}

  def parse_file_stream!(file_path, specs_dir, tests_dir) do
    state =
      file_path
      |> init_state(specs_dir, tests_dir)
      |> parse_file_lines()
      |> finalize_validation()

    state.spec
  end

  defp init_state(file_path, specs_dir, tests_dir) do
    spec_file_path = Path.relative_to(file_path, specs_dir)

    %{
      spec: %Spec{
        path: spec_file_path,
        test_path: test_path(spec_file_path, tests_dir)
      },
      file_path: file_path,
      in_acceptance_criteria?: false,
      acceptance_criteria_found?: false,
      has_criteria_tests?: false,
      current_scenario: nil,
      current_scenario_has_tests?: false,
      has_any_scenarios?: false,
      scenario_titles: MapSet.new(),
      title_found?: false
    }
  end

  defp test_path(spec_file_path, tests_dir) do
    Path.join(
      tests_dir,
      spec_file_path
      |> Path.rootname()
      |> Kernel.<>("_test.exs")
    )
    |> Path.relative_to(tests_dir)
  end

  defp parse_file_lines(%{file_path: file_path} = state) do
    file_path
    |> File.stream!(:line)
    |> Enum.reduce(state, fn line, acc_state ->
      line
      |> parse_line()
      |> handle_line(acc_state)
    end)
  end

  defp parse_line("# " <> rest), do: {:title, String.trim(rest)}
  defp parse_line("## Acceptance Criteria" <> _rest), do: :acceptance_criteria
  defp parse_line("## " <> _rest), do: :section_heading
  defp parse_line("### Scenario: " <> rest), do: {:scenario, String.trim(rest)}
  defp parse_line("-" <> rest), do: {:list_item, String.trim(rest)}
  defp parse_line("*" <> rest), do: {:list_item, String.trim(rest)}
  defp parse_line("+" <> rest), do: {:list_item, String.trim(rest)}
  defp parse_line(_line), do: :ignore

  defp handle_line({:title, title}, state) do
    next_state =
      if state.title_found? do
        add_error(state, "Title is repeated")
      else
        spec = %{state.spec | title: title}
        %{state | spec: spec}
      end

    %{next_state | title_found?: true}
  end

  defp handle_line(:acceptance_criteria, state) do
    state = validate_current_scenario_before_transition(state)

    state =
      if state.acceptance_criteria_found? do
        add_error(state, "Acceptance criteria section is repeated")
      else
        state
      end

    state
    |> Map.put(:in_acceptance_criteria?, true)
    |> Map.put(:acceptance_criteria_found?, true)
    |> Map.put(:current_scenario, nil)
    |> Map.put(:current_scenario_has_tests?, false)
  end

  defp handle_line(:section_heading, state) do
    state
    |> validate_current_scenario_before_transition()
    |> Map.put(:in_acceptance_criteria?, false)
    |> Map.put(:current_scenario, nil)
    |> Map.put(:current_scenario_has_tests?, false)
  end

  defp handle_line({:scenario, scenario_title}, %{in_acceptance_criteria?: true} = state) do
    state = validate_current_scenario_before_transition(state)

    state =
      if MapSet.member?(state.scenario_titles, scenario_title) do
        add_error(state, "Scenario is repeated: #{scenario_title}")
      else
        %{state | scenario_titles: MapSet.put(state.scenario_titles, scenario_title)}
      end

    %{
      state
      | current_scenario: scenario_title,
        current_scenario_has_tests?: false,
        has_any_scenarios?: true
    }
  end

  defp handle_line({:scenario, _scenario_title}, state), do: state

  defp handle_line({:list_item, test_name}, %{in_acceptance_criteria?: true} = state) do
    test = %Test{name: test_name, scenario_name: state.current_scenario}

    spec =
      try do
        Spec.add_test!(state.spec, test)
      rescue
        ArgumentError ->
          err_msg = "Test is repeated: #{test_name}"

          err_msg =
            if state.current_scenario,
              do: err_msg <> " - Scenario: #{state.current_scenario}"

          add_error(state, err_msg).spec
      end

    %{
      state
      | spec: spec,
        has_criteria_tests?: true,
        current_scenario_has_tests?: true
    }
  end

  defp handle_line({:list_item, _test_name}, state), do: state
  defp handle_line(:ignore, state), do: state

  defp finalize_validation(state) do
    state
    |> validate_current_scenario_before_transition()
    |> validate_title_presence()
    |> validate_acceptance_criteria()
  end

  defp validate_title_presence(%{title_found?: false} = state),
    do: add_error(state, "Title not found in spec file")

  defp validate_title_presence(state), do: state

  defp validate_acceptance_criteria(%{acceptance_criteria_found?: false} = state),
    do: add_error(state, "Acceptance criteria section not found")

  defp validate_acceptance_criteria(%{has_criteria_tests?: false} = state),
    do: add_error(state, "Acceptance criteria section is empty")

  defp validate_acceptance_criteria(state), do: state

  defp validate_current_scenario_before_transition(
         %{
           has_any_scenarios?: true,
           current_scenario: scenario,
           current_scenario_has_tests?: false
         } = state
       )
       when not is_nil(scenario) do
    add_error(state, "Scenario is empty: #{scenario}")
  end

  defp validate_current_scenario_before_transition(state), do: state

  defp add_error(state, error_msg) do
    spec = state.spec
    new_errors = spec.errors ++ [error_msg]
    spec = %{spec | errors: new_errors, status: :failed}
    %{state | spec: spec}
  end
end
