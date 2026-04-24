defmodule SpecsRunner.Core do
  @moduledoc false

  alias SpecsRunner.{Scenario, Spec, Test}

  @type item :: Spec.t() | Scenario.t() | Test.t()

  @spec set_pending(item(), String.t() | nil) :: item()
  def set_pending(item, reason \\ nil), do: set_status(item, :pending, reason)

  @spec set_passed(item()) :: item()
  def set_passed(item), do: set_status(item, :passed, nil)

  @spec set_failed(item(), String.t() | nil) :: item()
  def set_failed(item, reason \\ nil), do: set_status(item, :failed, reason)

  defp set_status(%Spec{} = item, status, error), do: %{item | status: status, error: error}
  defp set_status(%Scenario{} = item, status, error), do: %{item | status: status, error: error}
  defp set_status(%Test{} = item, status, error), do: %{item | status: status, error: error}
end
