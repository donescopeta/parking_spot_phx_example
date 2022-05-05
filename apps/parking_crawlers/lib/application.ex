defmodule ParkingCrawlers.Application do
  @moduledoc false

  alias ParkingCrawlers.ResolveParkingSpotDataSupervisor

  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: ParkingCrawlers.Registry},
      {ResolveParkingSpotDataSupervisor, name: ResolveParkingSpotDataSupervisor}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ParkingCrawlers.Supervisor)
  end
end
