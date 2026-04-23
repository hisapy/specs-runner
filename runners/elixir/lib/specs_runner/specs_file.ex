defmodule SpecsRunner.SpecsFile do
  @moduledoc false

  @spec list(String.t()) :: {:ok, [String.t()]} | {:error, String.t()}
  def list(specs_dir) do
    specs_dir
    |> Path.join("**/*.md")
    |> Path.wildcard()
    |> Enum.sort()
    |> then(&{:ok, &1})
  end

  @spec test_file_path(String.t(), String.t(), String.t()) :: String.t()
  def test_file_path(spec_path, specs_dir, tests_dir) do
    relative = Path.relative_to(spec_path, specs_dir)
    test_name = relative |> Path.rootname() |> Kernel.<>("_test.exs")
    Path.join(tests_dir, test_name)
  end

  @spec exists?(String.t()) :: boolean()
  def exists?(path), do: File.exists?(path)
end
