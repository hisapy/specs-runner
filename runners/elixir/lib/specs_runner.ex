defmodule SpecsRunner do
  @moduledoc false

  def run(specs_dir, tests_dir) when is_binary(specs_dir) and is_binary(tests_dir) do
    with :ok <- validate_dir(specs_dir),
         :ok <- validate_dir(tests_dir) do
      {:ok, nil}
      # %{specs_dir: specs_dir, tests_dir: tests_dir}
      # |> discover_specs()
      # |> match_specs()
      # |> format_report()
      # |> emit_report()
    end
  end

  defp validate_dir(path) do
    if File.dir?(path), do: :ok, else: {:error, "#{path}: Directory not found"}
  end

  # # Boundary placeholder: spec discovery is implemented in a later increment.
  # defp discover_specs(options), do: options

  # # Core placeholder: matching/classification is implemented in a later increment.
  # defp match_specs(options), do: options

  # # Core placeholder: report formatting is implemented in a later increment.
  # defp format_report(_options), do: []

  # # Boundary placeholder: output emission is implemented in a later increment.
  # defp emit_report(lines) when is_list(lines) do
  #   Enum.each(lines, &IO.puts/1)
  #   :ok
  # end
end
