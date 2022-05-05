defmodule Web.ParkingSpotController do
  use Web, :controller

  plug :put_view, Web.ParkingSpotView

  def show(conn, params) do
    id = Map.get(params, "id")

    case ParkingCrawlers.get_spot_data(id) do
      {:ok, data} ->
        conn
        |> put_status(200)
        |> render("spot.json", %{data: data})

      {:error, :not_found} ->
        conn
        |> put_status(404)
        |> render("message.json", %{message: "Not found."})
    end
  end
end
