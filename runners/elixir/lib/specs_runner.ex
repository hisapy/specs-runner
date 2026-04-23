defmodule SpecsRunner do
  @moduledoc false

  def run(specs_dir, tests_dir) when is_binary(specs_dir) and is_binary(tests_dir) do
    with :ok <- validate_dir(specs_dir),
         :ok <- validate_dir(tests_dir) do
      result = %SpecsRunner.Result{specs_dir: specs_dir, tests_dir: tests_dir}

      result
      |> discover_specs()
      # |> match_specs()
      # |> format_report()
      # |> emit_report()
      |> then(&{:ok, &1})
    end
  end

  defp validate_dir(path) do
    if File.dir?(path), do: :ok, else: {:error, "#{path}: Directory not found"}
  end

  defp discover_specs(%SpecsRunner.Result{specs_dir: specs_dir} = result) do
    {:ok, spec_paths} = SpecsRunner.SpecsFile.list(specs_dir)
    %{result | total: length(spec_paths)}
  end

  # Core placeholder: matching/classification is implemented in a later increment.
  # defp match_specs(result), do: result

  # Core placeholder: report formatting is implemented in a later increment.
  # defp format_report(result), do: result

  # Boundary placeholder: output emission is implemented in a later increment.
  # defp emit_report(result) do
  #   :ok
  # end
end
