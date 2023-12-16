defmodule Day16 do
  def call(type) do
    data = load(type)

    grid = prepare_grid(data)

    move(%{x: 0, y: 0, direction: :right}, :right, [], grid)
    |> Enum.map(&%{x: &1.x, y: &1.y})
    |> Enum.uniq()
    |> length
  end

  def move(current_coordinates, current_direction, visited_tiles, grid) do
    IO.inspect(current_coordinates, label: "CURRENT")
    IO.inspect(visited_tiles |> length(), label: "VISITED")

    if current_coordinates in visited_tiles do
      visited_tiles
    else
      visited_tiles = [current_coordinates | visited_tiles]

      case make_step(current_coordinates.x, current_coordinates.y, current_direction, grid) do
        :out ->
          visited_tiles

        [:out, :out] ->
          visited_tiles

        [coordinate_a, :out] ->
          move(coordinate_a, coordinate_a.direction, visited_tiles, grid)

        [:out, coordinate_b] ->
          move(coordinate_b, coordinate_b.direction, visited_tiles, grid)

        [coordinate_a, coordinate_b] ->
          tiles_visited_in_path_a =
            move(coordinate_a, coordinate_a.direction, visited_tiles, grid)

          move(coordinate_b, coordinate_b.direction, tiles_visited_in_path_a, grid)

        new_coordinates ->
          move(new_coordinates, new_coordinates.direction, visited_tiles, grid)
      end
    end
  end

  def make_step(x, y, direction, grid) do
    current_tile = grid |> Enum.at(y) |> Enum.at(x) |> IO.inspect(label: "CURRENT TILE")
    IO.puts("---------------------------")

    case switch_direction(current_tile, direction) do
      :up ->
        handle_up(x, y)

      :down ->
        handle_down(x, y, length(grid))

      :left ->
        handle_left(x, y)

      :right ->
        handle_right(x, y, length(grid))

      [:up, :down] ->
        [handle_up(x, y), handle_down(x, y, length(grid))]

      [:left, :right] ->
        [handle_left(x, y), handle_right(x, y, length(grid))]
    end
  end

  def switch_direction(".", direction), do: direction
  def switch_direction("|", direction) when direction in [:right, :left], do: [:up, :down]
  def switch_direction("|", direction), do: direction

  def switch_direction("-", direction) when direction in [:up, :down], do: [:left, :right]
  def switch_direction("-", direction), do: direction

  def switch_direction("\\", :right), do: :down
  def switch_direction("\\", :left), do: :up
  def switch_direction("\\", :up), do: :left
  def switch_direction("\\", :down), do: :right

  def switch_direction("/", :right), do: :up
  def switch_direction("/", :left), do: :down
  def switch_direction("/", :up), do: :right
  def switch_direction("/", :down), do: :left

  def prepare_grid(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
    end)
  end

  defp handle_up(x, y) do
    x = x
    y = y - 1

    if y < 0 do
      :out
    else
      %{x: x, y: y, direction: :up}
    end
  end

  def handle_down(x, y, grid_size) do
    x = x
    y = y + 1

    if y >= grid_size do
      :out
    else
      %{x: x, y: y, direction: :down}
    end
  end

  def handle_left(x, y) do
    x = x - 1
    y = y

    if x < 0 do
      :out
    else
      %{x: x, y: y, direction: :left}
    end
  end

  def handle_right(x, y, grid_size) do
    x = x + 1
    y = y

    if x >= grid_size do
      :out
    else
      %{x: x, y: y, direction: :right}
    end
  end

  def load(:example) do
    File.read!("lib/day16/example.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(16) |> String.trim()
end
