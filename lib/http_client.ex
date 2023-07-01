defmodule Servy.HttpClient do
  defp generate_request do
    """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
  end

  def send_request(port, req \\ generate_request()) do
    host = 'localhost'
    {:ok, sock} = :gen_tcp.connect(host, port, [:binary, packet: :raw, active: false])
    :ok = :gen_tcp.send(sock, req)
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
# response = Servy.HttpClient.send_request(port)

# IO.puts(response)
