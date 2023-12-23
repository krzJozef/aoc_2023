defmodule Day21 do
  def call(steps, type \\ :example) do
    data = load(type)

    map = prepare_map(data)
    starting_point = find_starting_point(map)

    number_of_steps = steps

    1..number_of_steps
    |> Enum.reduce([starting_point], fn _, steps_coordinates ->
      Enum.reduce(steps_coordinates, [], fn coordinates, possible_steps ->
        new_possible_steps = find_possible_steps(coordinates, map)

        new_possible_steps ++ possible_steps
      end)
      |> Enum.uniq()
    end)
    |> Enum.count()
  end

  def find_possible_steps({x, y}, map) do
    vertical_size = length(map)
    horizontal_size = length(Enum.at(map, 0))

    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.reject(fn {x, y} ->
      x < 0 or x >= horizontal_size or y < 0 or y >= vertical_size
    end)
    |> Enum.reject(fn {x, y} ->
      map |> Enum.at(y) |> Enum.at(x) == "#"
    end)
  end

  def prepare_map(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
    end)
  end

  def find_starting_point(map) do
    y =
      map
      |> Enum.find_index(fn row ->
        Enum.find_index(row, fn element ->
          element == "S"
        end)
      end)

    x =
      map
      |> Enum.at(y)
      |> Enum.find_index(&(&1 == "S"))

    {x, y}
  end

  def load(:example) do
    File.read!("lib/day21/example2.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(21) |> String.trim()
end
