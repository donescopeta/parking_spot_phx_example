defmodule ParkingCrawlers.ResolveParkingSpotDataSupervisor do
  use Supervisor

  alias ParkingCrawlers.ResolveParkingSpotDataWorker

  def start_link(resources) do
    Supervisor.start_link(__MODULE__, resources, name: __MODULE__)
  end

  @impl true
  def init(resources) do
    delay = ceil(:timer.minutes(1) / max_requests_per_minute())

    children =
      for {resource, i} <- Enum.with_index(resources()) do
        %{
          id: "ResolveParkingSpotDataWorker__" <> resource.id,
          start: {
            ResolveParkingSpotDataWorker,
            :start_link,
            [resource, [delay: delay * i]]
          }
        }
      end

    Supervisor.init(children, strategy: :one_for_one)
  end

  def resources(), do: Application.get_env(:parking_crawlers, :resources)

  def max_requests_per_minute() do
    Application.get_env(:parking_crawlers, :max_requests_per_minute)
  end
end
