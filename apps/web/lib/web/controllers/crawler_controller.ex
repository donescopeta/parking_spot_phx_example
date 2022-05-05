defmodule Web.CrawlerController do
  use Web, :controller

  plug :put_view, Web.CrawlerView

  def update(conn, params) do
    id = Map.get(params, "id")
    refresh_period = Map.get(params, "refresh_period", "")

    with {:period, true} <-
           {:period, is_integer(refresh_period)},
         :ok <- ParkingCrawlers.set_refresh_period(id, refresh_period) do
      conn
      |> put_status(200)
      |> render("crawler.json", %{id: id, refresh_period: refresh_period})
    else
      {:error, :not_found} ->
        conn
        |> put_status(404)
        |> render("message.json", %{message: "Not found."})

      {:period, _} ->
        conn
        |> put_status(400)
        |> render("message.json", %{message: "Invalid refresh period"})
    end
  end
end
