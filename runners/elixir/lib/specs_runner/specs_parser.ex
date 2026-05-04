defmodule SpecsRunner.SpecsParser do
  @moduledoc false

  alias SpecsRunner.Core.Run

  def parse_file_stream!(spec_file_path, %Run{} = run) do
    state =
      spec_file_path
      |> init_state(run)
      |> parse_file_lines()
      |> finalize_validation()

    state.run
  end

  defp init_state(spec_file_path, run) do
    %{
      run: Run.add_spec(run, spec_file_path),
      spec_file_path: spec_file_path,
      in_acceptance_criteria?: false,
      acceptance_criteria_found?: false,
      has_criteria_tests?: false,
      current_scenario: nil,
      current_scenario_has_tests?: false,
      has_any_scenarios?: false,
      scenario_titles: MapSet.new(),
      title_count: 0
    }
  end

  defp parse_file_lines(%{spec_file_path: spec_file_path} = state) do
    spec_file_path
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
      if state.title_count > 0 do
        add_error(state, "Title is repeated")
      else
        %{state | run: Run.set_spec_title(state.run, state.spec_file_path, title)}
      end

    %{next_state | title_count: state.title_count + 1}
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
    test_key = {state.spec_file_path, state.current_scenario, test_name}

    %{
      state
      | run: Run.add_test(state.run, test_key),
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

  defp validate_title_presence(%{title_count: 0} = state),
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
    %{state | run: Run.add_error(state.run, state.spec_file_path, error_msg)}
  end
end
