defmodule Recurse do
  def sum(list) do
    sum(list, 0)
  end

  def sum([head | tail], num) do
    sum(tail, num + head)
  end

  def sum([], num), do: num

  def triple([head | tail]) do
    [head * 3 | triple(tail)]
  end

  def triple([]), do: []

  def my_map([head | tail], func) do
    [func.(head) | my_map(tail, func)]
  end

  def my_map([], _func), do: []
end

IO.puts Recurse.sum([1, 2, 3, 4, 5])
IO.inspect Recurse.triple([1, 2, 3, 4, 5])
IO.inspect Recurse.my_map([1, 2, 3], fn x -> x * 2 end)
