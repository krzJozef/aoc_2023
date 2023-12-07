defmodule Day3.Part2 do
  def call do
    data = load()

    numbers_coordinations = number_coordinates(data)
    symbols_coordinations = symbol_coordinations(data)

    get_numbers_next_to_symbols(numbers_coordinations, symbols_coordinations)
    |> Enum.sum()
  end

  def number_coordinates(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      normalized =
        line
        |> String.trim()
        |> then(fn line -> Regex.replace(~r/[^0-9]/, line, ".") end)

      numbers =
        normalized
        |> String.split(".", trim: true)
        |> Enum.reject(&(&1 == ""))

      coordinates =
        normalized
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.reject(fn {char, _} -> char == "." end)

      numbers
      |> Enum.reduce(%{result: [], coordinates: coordinates}, fn number, acc ->
        length = String.length(number)
        {coordinates, rest_of_coordinates} = Enum.split(acc.coordinates, length)

        coordinates = Enum.map(coordinates, fn {_, x} -> {y, x} end)

        number = String.to_integer(number)
        %{result: [[number | coordinates] | acc.result], coordinates: rest_of_coordinates}
      end)
      |> Map.get(:result)
    end)
    |> Enum.reject(&(&1 == []))
  end

  def get_numbers_next_to_symbols(numbers_coordinations, symbols_coordinations) do
    symbols_coordinations
    |> Enum.map(fn {x, y} ->
      numbers_next_to_symbol =
        Enum.filter(numbers_coordinations, fn [_number | coordinations] ->
          {x - 1, y} in coordinations or
            {x - 1, y - 1} in coordinations or
            {x - 1, y + 1} in coordinations or
            {x + 1, y} in coordinations or
            {x + 1, y - 1} in coordinations or
            {x + 1, y + 1} in coordinations or
            {x, y + 1} in coordinations or
            {x, y - 1} in coordinations
        end)

      if length(numbers_next_to_symbol) == 2 do
        [[n1 | _], [n2 | _]] = numbers_next_to_symbol
        n1 * n2
      else
        nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  def symbol_coordinations(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.trim()
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.filter(fn {char, _} ->
        char == "*"
      end)
      |> Enum.map(fn {_, x} -> {y, x} end)
    end)
  end

  defp load do
    Api.get_input(3) |> String.trim()
  end

  def load_example do
    "467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598.."
    |> String.trim()
  end
end
