defmodule Day18.Part2 do
  def call(type \\ :example) do
    data = load(type)

    edges = find_edges(data)
    shoelace = shoelace(edges, 0)
    walls = count_walls(data)

    shoelace + 1 - walls / 2 + walls
  end

  def shoelace(edges, result) do
    if length(edges) < 2 do
      div(result, 2)
    else
      [{first_x, first_y}, {second_x, second_y}] = Enum.take(edges, 2)

      res = first_x * second_y - second_x * first_y

      [_ | tail] = edges

      shoelace(tail, result + res)
    end
  end

  def count_walls(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, fn line, acc ->
      [_direction, _length, hex] = String.split(line, " ", trim: true)

      {length, _} =
        hex
        |> String.slice(2, 5)
        |> Integer.parse(16)

      acc + length
    end)
  end

  def find_edges(data) do
    instructions =
      data
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [_direction, _length, hex] = String.split(line, " ", trim: true)

        {length, _} =
          hex
          |> String.slice(2, 5)
          |> Integer.parse(16)

        {String.at(hex, 7), length}
      end)

    Enum.reduce(instructions, [{0, 0}], fn {direction, length}, edges ->
      {x, y} = List.first(edges)

      next_edge =
        case direction do
          "0" ->
            {x + length, y}

          "2" ->
            {x - length, y}

          "3" ->
            {x, y - length}

          "1" ->
            {x, y + length}
        end

      [next_edge | edges]
    end)
    |> Enum.reverse()
  end

  def load(:example) do
    File.read!("lib/day18/example.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(18) |> String.trim()
end
