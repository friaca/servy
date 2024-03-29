defmodule Servy.Bear do
  alias Servy.Bear

  @derive Jason.Encoder
  defstruct id: nil,
            name: "",
            type: "",
            hibernating: false

  def is_grizzly(%Bear{} = bear) do
    bear.type == "Grizzly"
  end

  def order_asc_by_name(b1, b2) do
    b1.name <= b2.name
  end
end
