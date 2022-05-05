defmodule ParkingCrawlers do
  defdelegate get_spot_data(id),
    to: ParkingCrawlers.LookupParkingData,
    as: :call

  defdelegate set_refresh_period(id, period_mins),
    to: ParkingCrawlers.SetWorkerRefreshPeriod,
    as: :call
end
