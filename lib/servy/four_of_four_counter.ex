defmodule Servy.FourOhFourCounter do

  @name :four_oh_four_counter

  def start(initial_state \\ %{}) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid, @name)
    pid
  end

  def bump_count(route) do
    send(@name, {self(), :bump_count, route})
  end

  def get_count(route) do
    send(@name, {self(), :get_count, route})

    receive do {:result_count, count} -> count end
  end

  def get_counts() do
    send(@name, {self(), :get_counts})

    receive do {:result_counts, value} -> value end
  end

  def listen_loop(state) do
    receive do
      {_sender, :bump_count, route} ->
        new_state = Map.update(state, route, 1, fn count -> count + 1 end)
        listen_loop(new_state)

      {sender, :get_count, route} ->
        send(sender, {:result_count, Map.get(state, route, 0)})
        listen_loop(state)

      {sender, :get_counts} ->
        send(sender, {:result_counts, state})
        listen_loop(state)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        listen_loop(state)
    end
  end
end
