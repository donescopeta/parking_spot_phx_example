defmodule Web.ParkingSpotView do
  use Web, :view

  def render("spot.json", %{data: data}) do
    %{
      taken_places: data["properties"]["num_of_taken_places"],
      total_places: data["properties"]["total_num_of_places"]
    }
  end

  def render("message.json", %{message: message}) do
    %{message: message}
  end
end
