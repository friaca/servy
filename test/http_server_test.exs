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

  test "accepts requests in multiple endpoints and returns the responses correctly" do
    port = 4000

    spawn(Servy.HttpServer, :start, [port])

    urls =
      ["wildthings", "bears", "bears/1", "wildlife", "api/bears"]
      |> Enum.map(fn endpoint -> "http://localhost:#{port}/#{endpoint}" end)

    urls
    |> Enum.map(&Task.async(fn -> HTTPoison.get(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_successful_response/1)
  end

  defp assert_successful_response({:ok, response}) do
    assert response.status_code == 200
  end
end
