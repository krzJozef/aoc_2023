defmodule Day11.Part2 do
  def call do
    data = load(:input)

    galaxy = build_galaxy(data)
    expanded_galaxy = expand_galaxy(galaxy)

    pairs = connect_in_pairs(expanded_galaxy)

    pairs
    |> Enum.map(&calculate_distance/1)
  end

  def expand_galaxy(galaxy) do
    # Both example and input have stars in the last row and column, so this naive approach works
    max_y = galaxy |> Enum.max_by(& &1.y) |> Map.get(:y)
    max_x = galaxy |> Enum.max_by(& &1.x) |> Map.get(:x)

    horizontal_expansion_points =
      Enum.reject(0..max_x, fn x ->
        Enum.any?(galaxy, &(&1.x == x))
      end)

    vertical_expansion_points =
      Enum.reject(0..max_y, fn y ->
        Enum.any?(galaxy, &(&1.y == y))
      end)

    extended_galaxy =
      horizontal_expansion_points
      |> Enum.reverse()
      |> Enum.reduce(galaxy, fn x, extended_galaxy ->
        Enum.map(extended_galaxy, fn coordinates ->
          if coordinates.x > x do
            %{coordinates | x: coordinates.x + 999_999}
          else
            coordinates
          end
        end)
      end)

    vertical_expansion_points
    |> Enum.reverse()
    |> Enum.reduce(extended_galaxy, fn y, extended_galaxy ->
      Enum.map(extended_galaxy, fn coordinates ->
        if coordinates.y > y do
          %{coordinates | y: coordinates.y + 999_999}
        else
          coordinates
        end
      end)
    end)
  end

  def connect_in_pairs(galaxy) do
    galaxy
    |> Enum.reduce({[], []}, fn star, {pairs, visited} ->
      visiting =
        galaxy
        |> Enum.reject(&(&1 in visited))

      new_pairs =
        visiting
        |> Enum.map(fn other_star ->
          if other_star != star do
            [star, other_star]
          end
        end)
        |> Enum.reject(&is_nil/1)

      {pairs ++ new_pairs, [star | visited]}
    end)
    |> elem(0)
  end

  def calculate_distance([a, b]) do
    abs(a.x - b.x) + abs(a.y - b.y)
  end

  def build_galaxy(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.trim()
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn
        {"#", x} ->
          %{x: x, y: y}

        {".", _x} ->
          nil
      end)
      |> Enum.reject(&is_nil/1)
    end)
  end

  def load(:example) do
    "...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#....."
  end

  def load(:input), do: Api.get_input(11) |> String.trim()
end
