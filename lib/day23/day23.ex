defmodule Day23 do
  use Memoize

  def call(type \\ :example) do
    data = load(type)
    map = build_map(data)

    end_point = find_end_point(map)
    start = {1, 0, "."}

    loop(start, [], map, end_point)
    |> List.flatten()
    |> Enum.max()
  end

  def loop(current_node, current_path, grid, end_point) do
    {current_x, current_y, current_char} = current_node
    {endpoint_x, endpoint_y} = end_point

    if current_x == endpoint_x and current_y == endpoint_y do
      # We're at the end
      length(current_path)
    else
      current_path = [
        {current_x, current_y} | current_path
      ]

      neighbours =
        cond do
          {1, 0, "."} == current_node ->
            # We're at the starting point
            [{current_x, current_y + 1, "."}]

          current_char in [">", "<", "v", "^"] ->
            neighbour =
              case current_char do
                ">" ->
                  x = current_x + 1
                  y = current_y
                  {x, y, Enum.at(grid, y) |> Enum.at(x)}

                "<" ->
                  x = current_x - 1
                  y = current_y
                  {x, y, Enum.at(grid, y) |> Enum.at(x)}

                "^" ->
                  x = current_x
                  y = current_y - 1
                  {x, y, Enum.at(grid, y) |> Enum.at(x)}

                "v" ->
                  x = current_x
                  y = current_y + 1
                  {x, y, Enum.at(grid, y) |> Enum.at(x)}
              end

            [neighbour]

          true ->
            [
              {current_x + 1, current_y},
              {current_x - 1, current_y},
              {current_x, current_y + 1},
              {current_x, current_y - 1}
            ]
            |> Enum.reject(fn {x, y} ->
              x < 0 or x >= Enum.at(grid, 0) |> length() or y < 0 or y >= length(grid) or
                Enum.at(grid, y) |> Enum.at(x) == "#" or {x, y} in current_path
            end)
            |> Enum.map(fn {x, y} ->
              {x, y, Enum.at(grid, y) |> Enum.at(x)}
            end)
            |> Enum.reject(fn {x, y, char} ->
              (x == current_x - 1 and char == ">") or (x == current_x + 1 and char == "<") or
                (y == current_y - 1 and char == "v") or (y == current_y + 1 and char == "^")
            end)
        end

      Enum.map(neighbours, fn neighbour ->
        loop(neighbour, current_path, grid, end_point)
      end)
    end
  end

  def find_end_point(map) do
    y = length(map) - 1

    x = Enum.at(map, y) |> Enum.find_index(fn char -> char == "." end)

    {x, y}
  end

  def build_map(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
    end)
  end

  def load(:example) do
    File.read!("lib/day23/example.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(23) |> String.trim()
end
