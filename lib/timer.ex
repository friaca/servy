defmodule Timer do
  def remind(name, time_seconds) do
    spawn(fn ->
      :timer.sleep(time_seconds * 1000)
      IO.puts(name)
    end)
  end
end

# Timer.remind("Stand Up", 5)
# Timer.remind("Sit Down", 10)
# Timer.remind("Fight, Fight, Fight", 15)

# :timer.sleep(:infinity)
