defmodule Day9.Part2 do
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
      |> calculate_first_numbers()
    end)
    |> Enum.sum()
  end

  def extrapolate(numbers) do
    differences = get_differences(numbers)

    extrapolate(differences, [List.first(numbers)])
  end

  def extrapolate(numbers, acc) do
    differences = get_differences(numbers)

    if Enum.all?(differences, &(&1 == 0)) do
      [List.first(numbers) | acc] |> Enum.reverse()
    else
      extrapolate(differences, [List.first(numbers) | acc])
    end
  end

  def calculate_first_numbers(numbers) do
    [base | rest] = numbers

    rest
    |> Enum.with_index()
    |> Enum.reduce(base, fn {number, index}, acc ->
      if rem(index, 2) == 0 do
        acc - number
      else
        acc + number
      end
    end)
  end

  def get_differences(numbers) do
    [_h | tail] = numbers

    Enum.zip_with(numbers, tail, fn x, y -> y - x end)
  end

  defp load do
    Api.get_input(9) |> String.trim()
  end
end
