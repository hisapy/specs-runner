defmodule SpecsRunner do
  @moduledoc false

  alias SpecsRunner.Core.Run
  alias SpecsRunner.SpecsParser

  def run(specs_dir, tests_dir) when is_binary(specs_dir) and is_binary(tests_dir) do
    with :ok <- validate_dir(specs_dir),
         :ok <- validate_dir(tests_dir) do
      run = Run.new(specs_dir, tests_dir)

      run =
        specs_dir
        |> Path.join("**/*.md")
        |> Path.wildcard()
        |> Stream.map(&SpecsParser.parse_file_stream!(&1, run))

      {:ok, run}
      # {:ok, %{run | end_time: DateTime.utc_now()}}
    end
  end

  defp validate_dir(path) do
    if File.dir?(path), do: :ok, else: {:error, "#{path}: Directory not found"}
  end
end
