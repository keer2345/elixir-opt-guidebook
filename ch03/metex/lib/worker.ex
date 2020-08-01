defmodule Metex.Worker do
  def loop do
    receive do
      {sender_pid, location} ->
        send(sender_pid, {:ok, temperature_of(location)})

      _ ->
        IO.puts("don't know how to process this message")
    end

    loop
  end

  def temperature_of(location) do
    result = url_for(location) |> HTTPoison.get() |> parse_response

    case result do
      {:ok, temp} -> "#{location}: #{temp}°C"
      :error -> "#{location} not found"
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey}"
  end

  defp parse_response(resp) do
    case resp do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        body |> JSON.decode() |> compute_temperature

      _ ->
        :error
    end
  end

  defp compute_temperature(json) do
    try do
      {:ok, json} = json
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp apikey do
    "dc4408560f0839350a00ed3420aa7445"
  end
end
