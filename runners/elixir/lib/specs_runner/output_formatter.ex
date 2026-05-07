defmodule SpecsRunner.OutputFormatter do
  @moduledoc false

  use GenServer

  alias SpecsRunner.Core.RunInfo

  @run_info_key {__MODULE__, :run_info}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def set_execution(%RunInfo{} = run_info) do
    :persistent_term.put(@run_info_key, run_info)

    case Process.whereis(__MODULE__) do
      nil -> :ok
      pid -> GenServer.call(pid, {:set_execution, run_info})
    end
  end

  def get_execution do
    case Process.whereis(__MODULE__) do
      nil -> :persistent_term.get(@run_info_key, nil)
      pid -> GenServer.call(pid, :get_execution)
    end
  end

  @impl GenServer
  def init(_opts) do
    {:ok, %{run_info: :persistent_term.get(@run_info_key, nil)}}
  end

  @impl GenServer
  def handle_call({:set_execution, run_info}, _from, state) do
    :persistent_term.put(@run_info_key, run_info)
    {:reply, :ok, %{state | run_info: run_info}}
  end

  @impl GenServer
  def handle_call(:get_execution, _from, state) do
    run_info = state.run_info || :persistent_term.get(@run_info_key, nil)
    {:reply, run_info, state}
  end

  @impl GenServer
  def handle_cast({:test_finished, %ExUnit.Test{} = test}, %{run_info: run_info} = state)
      when not is_nil(run_info) do
    updated_run_info = apply_test_result(run_info, test)
    :persistent_term.put(@run_info_key, updated_run_info)
    {:noreply, %{state | run_info: updated_run_info}}
  end

  @impl GenServer
  def handle_cast(_event, state), do: {:noreply, state}

  defp apply_test_result(run_info, test) do
    test_key = build_test_key(run_info, test)

    if Map.has_key?(run_info.tests, test_key) do
      case test.state do
        nil -> RunInfo.set_test_passed(run_info, test_key)
        {:failed, errors} -> RunInfo.set_test_failed(run_info, test_key, errors)
        _ -> run_info
      end
    else
      run_info
    end
  end

  defp build_test_key(run_info, test) do
    spec_file_path = test_file_to_spec_file(test.tags[:file], run_info)
    scenario_title = test.tags[:describe]
    test_name = test.name |> Atom.to_string() |> String.replace_prefix("test ", "")
    {spec_file_path, scenario_title, test_name}
  end

  defp test_file_to_spec_file(test_file, run_info) do
    base = Path.basename(test_file, "_test.exs")
    Path.join(run_info.specs_dir, "#{base}.md")
  end
end
