defmodule Servy.HttpClient do
  def generate_request do
    """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
  end

  def connect do
    host = 'localhost'
    {:ok, sock} = :gen_tcp.connect(host, 1973, [:binary, packet: :raw, active: false])
    :ok = :gen_tcp.send(sock, generate_request())
    {:ok, response} = :gen_tcp.recv(sock, 0)
    :ok = :gen_tcp.close(sock)
    response
  end
end

spawn(fn -> Servy.HttpServer.start(1973) end)
response = Servy.HttpClient.connect()

IO.puts(response)
