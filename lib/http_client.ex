defmodule Servy.HttpClient do
  def generate_request do
    """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
  end

  def connect(port) do
    host = 'localhost'
    {:ok, sock} = :gen_tcp.connect(host, port, [:binary, packet: :raw, active: false])
    :ok = :gen_tcp.send(sock, generate_request())
    {:ok, response} = :gen_tcp.recv(sock, 0)
    :ok = :gen_tcp.close(sock)
    response
  end
end

# port = 4000
# -- With anonymous function
# spawn(fn -> Servy.HttpServer.start(port) end)
# -- With named function
# spawn(Servy.HttpServer, :start, [port])
# response = Servy.HttpClient.connect(port)

# IO.puts(response)
