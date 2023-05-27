defmodule Servy.Plugins do
  import Logger

  alias Servy.Conv

  def log(%Conv{} = conv) do
    if Mix.env == :dev do
      IO.inspect(conv)
    end
    conv
  end

  def emojify(%Conv{status: 200} = conv) do
    %{conv | resp_body: "🎺 #{conv.resp_body} 🎺"}
  end

  def emojify(conv), do: conv

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(%Conv{} = conv, %{"thing" => thing, "id" => id}) do
    %{ conv | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(%Conv{} = conv, nil), do: conv

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env != :dev do
      warn("Warning: #{path} is on the loose!")
    end
    conv
  end

  def track(%Conv{status: 200, path: path} = conv) do
    info("#{path} completed successfully")
    conv
  end

  def track(%Conv{status: 500, path: path} = conv) do
    error("#{path} crashed!")
    conv
  end

  def track(%Conv{} = conv), do: conv
end
