defmodule SpecsRunner.ExUnitDebugFormatter do
  @moduledoc false

  use GenServer

  @impl GenServer
  def init(opts), do: {:ok, opts}

  @impl GenServer
  def handle_cast({:test_finished, %ExUnit.Test{} = test}, state) do
    IO.puts(:stderr, "EXUNIT_DEBUG_TEST #{inspect(test, pretty: true, limit: :infinity)}")
    IO.puts(:stderr, "EXUNIT_DEBUG_TEST #{inspect(test.module, pretty: true, limit: :infinity)}")
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast(_event, state), do: {:noreply, state}
end
