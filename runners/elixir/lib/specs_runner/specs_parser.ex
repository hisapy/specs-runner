defmodule SpecsRunner.SpecsParser do
  @moduledoc false

  alias SpecsRunner.Core.Run

  # @states [
  #   :spec_file_path,
  #   :spec_title,
  #   :acceptance_criteria,
  #   :scenario
  # ]

  def parse_file_stream!(spec_file_path, %Run{} = run) do
    run = Run.add_spec(run, spec_file_path)

    spec_file_path
    |> File.stream!(:line)
    |> Enum.reduce({run, nil}, fn line, {acc_run, current_scenario} ->
      case parse_line(line) do
        {:title, title} ->
          {Run.set_spec_title(acc_run, spec_file_path, title), current_scenario}

        {:scenario, scenario_title} ->
          {acc_run, scenario_title}

        {:list_item, test_name} ->
          test_key = {spec_file_path, current_scenario, test_name}
          {Run.add_test(acc_run, test_key), current_scenario}

        _ ->
          {acc_run, current_scenario}
      end
    end)
    |> elem(0)
  end

  defp parse_line("# " <> rest), do: {:title, String.trim(rest)}
  defp parse_line("### Scenario: " <> rest), do: {:scenario, String.trim(rest)}

  defp parse_line("-" <> rest), do: {:list_item, String.trim(rest)}
  defp parse_line("*" <> rest), do: {:list_item, String.trim(rest)}
  defp parse_line("+" <> rest), do: {:list_item, String.trim(rest)}

  defp parse_line(_line), do: :ignore
end
