defmodule Servy.KickStarter do
  use GenServer

  def start_link(_args) do
    IO.puts("Starting KickStarter")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_server do
    GenServer.call(__MODULE__, :get_server)
  end

  # Server

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_call(:get_server, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts("HTTP Server exited (#{inspect(reason)})")
    server_pid = start_server()
    {:noreply, server_pid}
  end

  def start_server do
    IO.puts("Starting HTTP Server")
    port = Application.get_env(:servy, :port)
    server_pid = spawn_link(Servy.HttpServer, :start, [port])
    Process.register(server_pid, :http_server)
    server_pid
  end
end
