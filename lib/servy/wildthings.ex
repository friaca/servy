defmodule Servy.Wildthings do
  alias Servy.Bear
  @bears_db Path.expand("db/bears.json", File.cwd!)

  def list_bears do
    {:ok, bears_json} = File.read(@bears_db)
    {:ok, %{bears: bears}} = Jason.decode(bears_json, keys: :atoms)
    bears |> Enum.map(fn bear -> struct(Bear, bear) end)
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn bear -> bear.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer() |> get_bear()
  end
end
