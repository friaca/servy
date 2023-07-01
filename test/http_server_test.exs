defmodule HttpServerTest do
  use ExUnit.Case
  doctest Servy.HttpServer

  test "accepts a request and returns a response correctly" do
    port = 4000
    spawn(Servy.HttpServer, :start, [port])

    request = """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = Servy.HttpClient.send_request(port, request)

    assert response == """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end
end
