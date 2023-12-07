defmodule Day3 do
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
    |> IO.inspect()

    # |> Enum.into(%{})
  end

  def get_numbers_next_to_symbols(numbers_coordinations, symbols_coordinations) do
    numbers_coordinations
    |> Enum.filter(fn [_number | coordinations] ->
      coordinations
      |> Enum.any?(fn {x, y} ->
        {x - 1, y} in symbols_coordinations or
          {x - 1, y - 1} in symbols_coordinations or
          {x - 1, y + 1} in symbols_coordinations or
          {x + 1, y} in symbols_coordinations or
          {x + 1, y - 1} in symbols_coordinations or
          {x + 1, y + 1} in symbols_coordinations or
          {x, y + 1} in symbols_coordinations or
          {x, y - 1} in symbols_coordinations
      end)
    end)
    |> Enum.map(fn [number | _coordinations] -> number end)
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
      |> Enum.reject(fn {char, _} ->
        char == "." or Integer.parse(char) != :error
      end)
      |> Enum.map(fn {_, x} -> {y, x} end)
    end)
  end

  def call2 do
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
