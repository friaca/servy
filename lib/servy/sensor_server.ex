defmodule Servy.SensorServer do
  defmodule State do
    defstruct sensor_data: %{},
              refresh_interval: :timer.minutes(60)
  end

  @name :sensor_server

  use GenServer

  # Client Interface

  def start_link(interval) do
    GenServer.start_link(__MODULE__, %State{refresh_interval: interval}, name: @name)
  end

  def get_sensor_data do
    GenServer.call(@name, :get_sensor_data)
  end

  def set_refresh_interval(time) do
    GenServer.cast(@name, {:set_refresh_interval, time})
  end

  # Server Callbacks

  def init(state) do
    IO.puts("Starting SensorServer with #{state.refresh_interval} min interval")
    initial_state = %{state | sensor_data: run_tasks_to_get_sensor_data()}
    schedule_refresh(:timer.minutes(state.refresh_interval))

    {:ok, initial_state}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:set_refresh_interval, time}, %State{} = state) do
    new_state = %{state | refresh_interval: time}
    {:noreply, new_state}
  end

  def handle_info(:refresh, state) do
    IO.puts("Refreshing sensor data cache...")
    new_state = %{state | sensor_data: run_tasks_to_get_sensor_data()}
    schedule_refresh(state.refresh_interval)
    {:noreply, new_state}
  end

  defp schedule_refresh(interval) do
    Process.send_after(self(), :refresh, interval)
  end

  defp run_tasks_to_get_sensor_data do
    IO.puts("Running tasks to get sensor data...")

    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end
end
