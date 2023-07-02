defmodule Servy.HttpServer do
  require Logger

  @doc """
  Starts the server on the given `port` of localhost.
  """
  def start(port \\ 4000) when is_integer(port) and port > 1023 do
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    Logger.info("\n🎧  Listening for connection requests on port #{port}...\n")

    accept_loop(listen_socket)
  end

  @doc """
  Accepts client connections on the `listen_socket`.
  """
  def accept_loop(listen_socket) do
    Logger.info("⌛️  Waiting to accept a client connection...\n")

    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    Logger.info("⚡️  Connection accepted!\n")

    pid = spawn(fn -> serve(client_socket) end)
    :ok = :gen_tcp.controlling_process(client_socket, pid)

    accept_loop(listen_socket)
  end

  @doc """
  Receives the request on the `client_socket` and
  sends a response back over the same socket.
  """
  def serve(client_socket) do
    Logger.info("#{inspect self()}: Working on it!")

    client_socket
    |> read_request
    |> Servy.Handler.handle()
    |> write_response(client_socket)
  end

  @doc """
  Receives a request on the `client_socket`.
  """
  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0) # all available bytes

    Logger.info("➡️  Received request:\n")
    IO.puts request

    request
  end

  @doc """
  Returns a generic HTTP response.
  """
  def generate_response(_request) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/plain
    Content-Length: 6

    Hello!
    """
  end

  @doc """
  Sends the `response` over the `client_socket`.
  """
  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)

    Logger.info("⬅️  Sent response:\n")
    IO.puts response

    # Closes the client socket, ending the connection.
    # Does not close the listen socket!
    :gen_tcp.close(client_socket)
  end

end
