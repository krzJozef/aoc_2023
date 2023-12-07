defmodule Day6 do
  def call do
    # example()
    load()
    |> load_races()
    |> Enum.map(&get_number_of_seconds_that_win/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.reduce(&(&1 * &2))
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
    [times, distances] =
      data
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [_, values_string] = String.split(line, ":", trim: true)

        values_string
        |> String.trim()
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    times
    |> Enum.zip(distances)
    |> Enum.map(fn {time, distance} ->
      %{
        time: time,
        distance: distance
      }
    end)
  end

  defp example do
    "Time:      7  15   30
    Distance:  9  40  200"
  end

  defp load do
    Api.get_input(6) |> String.trim()
  end
end
