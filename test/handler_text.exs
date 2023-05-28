defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 389

    <h1>All The Bears!</h1>

    <ul>
      <li>Brutus - Grizzly</li>
      <li>Iceman - Polar</li>
      <li>Kenai - Grizzly</li>
      <li>Paddington - Brown</li>
      <li>Roscoe - Panda</li>
      <li>Rosie - Black</li>
      <li>Scarface - Grizzly</li>
      <li>Smokey - Black</li>
      <li>Snow - Polar</li>
      <li>Teddy - Brown</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
    HTTP/1.1 404 Not Found
    Content-Type: text/html
    Content-Length: 17

    No /bigfoot here!
    """
  end

  test "GET /bears/1" do
    request = """
    GET /bears/1 HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 74

    <h1>Show Bear</h1>
    <p>
    Is Teddy hibernating? <strong>true</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /wildlife" do
    request = """
    GET /wildlife HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 327

    <h1>Clark's Wildthings Refuge</h1>

    <blockquote>
    When we contemplate the whole globe as one great dewdrop,
    striped and dotted with continents and islands, flying
    through space with other stars all singing and shining
    together as one, the whole universe appears as an infinite
    storm of beauty. -- John Muir
    </blockquote>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /bears" do
    request = """
    POST /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 21

    name=Baloo&type=Brown
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created
    Content-Type: text/html
    Content-Length: 33

    Created a Brown bear named Baloo!
    """
  end

  test "DELETE /bears" do
    request = """
    DELETE /bears/1 HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
    HTTP/1.1 403 Forbidden
    Content-Type: text/html
    Content-Length: 29

    Deleting a bear is forbidden!
    """
  end

  test "GET /api/bears" do
    request = """
    GET /api/bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: application/json
    Content-Length: 605

    [{"hibernating":true,"id":1,"name":"Teddy","type":"Brown"},
     {"hibernating":false,"id":2,"name":"Smokey","type":"Black"},
     {"hibernating":false,"id":3,"name":"Paddington","type":"Brown"},
     {"hibernating":true,"id":4,"name":"Scarface","type":"Grizzly"},
     {"hibernating":false,"id":5,"name":"Snow","type":"Polar"},
     {"hibernating":false,"id":6,"name":"Brutus","type":"Grizzly"},
     {"hibernating":true,"id":7,"name":"Rosie","type":"Black"},
     {"hibernating":false,"id":8,"name":"Roscoe","type":"Panda"},
     {"hibernating":true,"id":9,"name":"Iceman","type":"Polar"},
     {"hibernating":false,"id":10,"name":"Kenai","type":"Grizzly"}]
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
