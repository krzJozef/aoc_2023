defmodule Day6.Part2 do
  def call do
    # example()
    load()
    |> load_races()
    |> get_number_of_seconds_that_win()
    |> Enum.count()
  end

  def get_number_of_seconds_that_win(%{time: time, distance: distance}) do
    1..time
    |> Enum.filter(fn number_of_seconds ->
      calculate_distance(number_of_seconds, time) > distance
    end)
  end

  def calculate_distance(button_holding_time, total_time) do
    button_holding_time * (total_time - button_holding_time)
  end

  def load_races(data) do
    [time, distance] =
      data
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [_, values_string] = String.split(line, ":", trim: true)

        values_string
        |> String.trim()
        |> String.replace(" ", "")
        |> String.to_integer()
      end)

    %{time: time, distance: distance}
  end

  defp load do
    Api.get_input(6) |> String.trim()
  end
end
