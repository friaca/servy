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
end
