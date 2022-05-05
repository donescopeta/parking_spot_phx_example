defmodule ParkingCrawlers.ResolveParkingSpotDataWorker do
  use GenServer
  require Logger

  alias ParkingCrawlers.ResolveParkingSpotData

  @registry ParkingCrawlers.Registry

  @max_failures 15

  @restart_delay_mins 5

  @type worker_state :: %{
          refresh_period: integer(),
          id: String.t(),
          data: map(),
          failures: integer() | nil
        }

  @spec start_link(worker_state, any()) :: any()
  def start_link(state, opts \\ []) do
    delay = Keyword.get(opts, :delay, 0)

    GenServer.start_link(__MODULE__, {state, delay}, name: via_tuple(state.id))
  end

  @impl true
  def init({state, delay}) do
    Process.send_after(self(), :run, delay)

    {:ok, state}
  end

  def handle_continue(:schedule, state) do
    Process.send_after(self(), :run, :timer.minutes(state.refresh_period))

    {:noreply, state}
  end

  def handle_continue(:retry, %{failures: @max_failures} = state) do
    Process.send_after(self(), :restart, :timer.minutes(@restart_delay_mins))

    {:noreply, state}
  end

  def handle_continue(:retry, state) do
    Process.send_after(self(), :run, :timer.seconds(5))

    {:noreply, state}
  end

  @impl true
  def handle_continue(:run, state) do
    case ResolveParkingSpotData.call(state.id) do
      {:ok, data} ->
        new_state = Map.merge(state, %{
          data: data,
          failures: 0
        })

        {:noreply, new_state, {:continue, :schedule}}

      error ->
        Logger.info("Fetching parking-spot resource has failed", error: error)

        failures = (state[:failures] || 0) + 1

        {:noreply, %{state | failures: failures}, {:continue, :retry}}
    end
  end

  @impl true
  def handle_call(:get_data, _from, state) do
    {:reply, Map.get(state, :data), state}
  end

  @impl true
  def handle_cast({:set_refresh_period, period_mins}, state) do
    state = Map.put(state, :refresh_period, period_mins)

    {:noreply, state}
  end

  @impl true
  def handle_info(:run, state) do
    {:noreply, state, {:continue, :run}}
  end

  def handle_info(:restart, state) do
    {:stop, :shutdown, state}
  end

  defp via_tuple(id), do: {:via, Registry, {@registry, id}}
end
