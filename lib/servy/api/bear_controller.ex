defmodule Servy.Api.BearController do
  alias Servy.Handler

  def index(conv) do
    json = Servy.Wildthings.list_bears()
    |> Jason.encode!()

    conv = Handler.put_resp_content_type(conv, "application/json")

    %{conv | status: 200, resp_body: json }
  end

  def create(%Servy.Conv{} = conv) do
    %{ conv |
      status: 201,
      resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}!"}
  end
end
