defmodule Servy.Plugins do
  import Logger

  def log(conv), do: IO.inspect(conv)

  def emojify(%{status: 200} = conv) do
    %{conv | resp_body: "🎺 #{conv.resp_body} 🎺"}
  end

  def emojify(conv), do: conv

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{ conv | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(conv, nil), do: conv

  def track(%{status: 404, path: path} = conv) do
    warn("Warning: #{path} is on the loose!")
    conv
  end

  def track(%{status: 200, path: path} = conv) do
    info("#{path} completed successfully")
    conv
  end

  def track(%{status: 500, path: path} = conv) do
    error("#{path} crashed!")
    conv
  end

  def track(conv), do: conv
end
