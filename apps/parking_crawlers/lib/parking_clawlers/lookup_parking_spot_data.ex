defmodule ParkingCrawlers.LookupParkingData do
  @registry ParkingCrawlers.Registry

  @spec call(String.t()) :: {:ok, map()} | {:error, :not_found} | {:error, :invalid_data, any()}
  def call(id) do
    # TODO: In case of more requests use ETS
    with {:registry, [{pid, _}]} <-
           {:registry, Registry.lookup(@registry, id)},
         {:data, data = %{}} <- {:data, GenServer.call(pid, :get_data)} do
      {:ok, data}
    else
      {:registry, []} ->
        {:error, :not_found}

      {:data, data} ->
        {:error, :invalid_data, data}
    end
  end
end
