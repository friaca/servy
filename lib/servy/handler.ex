defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests.
  """

  @pages_path Path.expand("pages", File.cwd!)

  import Servy.Parser
  import Servy.FileHandler
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]

  alias Servy.Conv
  alias Servy.BearController

  @doc """
  Transforms the request into a response
  """
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> put_content_length
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/wildlife"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    Servy.Api.BearController.create(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    BearController.delete(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> page} = conv) do
    @pages_path
    |> Path.join("#{page}.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def put_resp_content_type(%Conv{} = conv, content_type) do
    %{ conv | resp_headers: Map.put(conv.resp_headers, "Content-Type", content_type) }
  end

  def put_content_length(%Conv{} = conv) do
    %{ conv | resp_headers: Map.put(conv.resp_headers, "Content-Length", byte_size(conv.resp_body)) }
  end

  def format_response_headers(%Conv{} = conv) do
    # For some reason, the Content-Type header doesn't get a "default" \r and break tests
    Enum.map(conv.resp_headers, fn {key, value} ->
      case key do
        "Content-Type" -> "#{key}: #{value}\r"
        _ -> "#{key}: #{value}"
      end

    end) |> Enum.sort |> Enum.reverse |> Enum.join("\n")
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    #{format_response_headers(conv)}

    #{conv.resp_body}
    """
  end
end
