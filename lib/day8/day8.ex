defmodule Day8 do
  def call do
    data = load()

    pattern = load_pattern(data)
    map = generate_map(data)
    current_location = "CBA"

    move(current_location, pattern, map, 1)
  end

  def move("XTZ" = current_location, pattern, map, step) do
    IO.inspect(step - 1)
    next_location = make_move(current_location, next_direction(pattern, step), map)

    move(next_location, pattern, map, step + 1)
  end

  def move(current_location, pattern, map, step) do
    next_location = make_move(current_location, next_direction(pattern, step), map)

    move(next_location, pattern, map, step + 1)
  end

  def make_move(current_location, "L", map), do: List.first(map[current_location])
  def make_move(current_location, "R", map), do: List.last(map[current_location])

  def next_direction(pattern, index) do
    pattern_length = String.length(pattern)

    collapsed_index =
      if index - 1 < pattern_length, do: index - 1, else: rem(index - 1, pattern_length)

    String.at(pattern, collapsed_index)
  end

  def generate_map(data) do
    [_, map_data] =
      data
      |> String.split("\n\n", trim: true)

    map_data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [key, values] =
        line
        |> String.trim()
        |> String.split(" = ", trim: true)

      values =
        values
        |> String.replace("(", "")
        |> String.replace(")", "")
        |> String.split(", ", trim: true)

      {key, values}
    end)
    |> Enum.into(%{})
  end

  def load_pattern(data) do
    [pattern, _] =
      data
      |> String.split("\n\n", trim: true)

    String.trim(pattern)
  end

  defp load do
    Api.get_input(8) |> String.trim()
  end
end
