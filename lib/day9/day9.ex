defmodule Day9 do
  def call do
    data = load()

    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> extrapolate()
      |> calculate_last_number()
    end)
    |> Enum.sum()
  end

  def extrapolate(numbers) do
    differences = get_differences(numbers)

    extrapolate(differences, [List.last(numbers)])
  end

  def extrapolate(numbers, acc) do
    differences = get_differences(numbers)

    if Enum.all?(differences, &(&1 == 0)) do
      [List.last(numbers) | acc]
    else
      extrapolate(differences, [List.last(numbers) | acc])
    end
  end

  def calculate_last_number(numbers) do
    Enum.sum(numbers)
  end

  def get_differences(numbers) do
    [_h | tail] = numbers

    Enum.zip_with(numbers, tail, fn x, y -> y - x end)
  end

  defp example do
    "0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45"
  end

  defp load do
    Api.get_input(9) |> String.trim()
  end
end
