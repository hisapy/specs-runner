defmodule SpecsRunner do
  @moduledoc false

  # alias SpecsRunner.Core.Run

  def run(specs_dir, tests_dir) when is_binary(specs_dir) and is_binary(tests_dir) do
    with :ok <- validate_dir(specs_dir),
         :ok <- validate_dir(tests_dir) do
      # run = Run.start(specs_dir, tests_dir)

      # specs = load_specs(run)
      # tests = run_tests(tests_dir)

      # |> load_specs()
      # # |> match_specs()
      # |> then(&{:ok, &1})

      {:ok, nil}
    end
  end

  defp validate_dir(path) do
    if File.dir?(path), do: :ok, else: {:error, "#{path}: Directory not found"}
  end

  # defp load_specs(%SpecsRunner.Run{specs_dir: specs_dir} = run) do
  #   {:ok, spec_paths} = SpecsRunner.SpecsFile.list(specs_dir)
  #   %{run | total: length(spec_paths)}
  # end

  # Core placeholder: matching/classification is implemented in a later increment.
  # defp match_specs(result), do: result
end
