defmodule Servy.Fetcher do

  def async(func) do
    caller = self()
    spawn(fn -> send(caller, {self(), :result, func.()}) end)
  end

  def get_result(pid) do
    receive do {^pid, :result, value} -> value end
  end
end
