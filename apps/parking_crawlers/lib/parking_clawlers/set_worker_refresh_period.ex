defmodule ParkingCrawlers.SetWorkerRefreshPeriod do
  @registry ParkingCrawlers.Registry

  @spec call(String.t(), integer) :: :ok | {:error, :not_found}
  def call(id, period_mins) do
    case Registry.lookup(@registry, id) do
      [{pid, _}] ->
        GenServer.cast(pid, {:set_refresh_period, period_mins})

      [] ->
        {:error, :not_found}
    end
  end
end
