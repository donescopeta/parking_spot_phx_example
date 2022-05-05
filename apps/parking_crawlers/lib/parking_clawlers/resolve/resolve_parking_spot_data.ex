defmodule ParkingCrawlers.ResolveParkingSpotData do
  use Tesla

  plug(Tesla.Middleware.JSON)

  @spec call(String.t()) ::
          {:ok, map()} | {:error, :unexpected_status, any()} | {:error, any()}
  def call(id) do
    with {:ok, %Tesla.Env{status: 200, body: body}} <- get(url() <> "/" <> id) do
      {:ok, body}
    else
      {:ok, resp} ->
        {:error, :unexpected_status, resp}

      error ->
        {:error, error}
    end
  end

  def url(), do: Application.get_env(:parking_crawlers, :endpoint_url)
end
