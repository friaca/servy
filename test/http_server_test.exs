defmodule HttpServerTest do
  use ExUnit.Case
  doctest Servy.HttpServer

  test "accepts a request and returns a response correctly" do
    port = 4000
    spawn(Servy.HttpServer, :start, [port])

    {:ok, response} = HTTPoison.get("http://localhost:#{port}/wildthings")

    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers"
  end

  test "accepts multiple requests and returns the responses correctly" do
    port = 4000
    parent = self()
    num_requests = 5

    spawn(Servy.HttpServer, :start, [port])

    tasks = for _ <- 1..num_requests do
      Task.async(HTTPoison, :get, ["http://localhost:#{port}/wildthings"])
    end

    Enum.map(tasks, fn task -> Task.await(task) end)
    |> Enum.map(fn {:ok, response} ->
      assert response.status_code == 200
      assert response.body == "Bears, Lions, Tigers"
    end)
  end
end
