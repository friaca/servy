defmodule UserApi do
  @host "https://jsonplaceholder.typicode.com"
  @endpoint "/users"

  def query(id) do
    url(id)
    |> HTTPoison.get
    |> handle_response
  end

  def url(id) do
    @host <> @endpoint <> "/" <> URI.encode(id)
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    city =
      Jason.decode!(body)
      |> get_in(["address", "city"])

    {:ok, city}
  end

  defp handle_response({:ok, %{status_code: _status, body: body}}) do
    message =
      Jason.decode!(body)
      |> Map.get("message")

    {:error, message}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end
end
