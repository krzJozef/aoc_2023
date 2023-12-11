defmodule Day10 do
  def call(first_step_direction) do
    data = load()

    loop_size =
      data
      |> build_map()
      |> calculate_loop_size(first_step_direction)

    loop_size / 2
  end

  def calculate_loop_size(map, first_step_direction) do
    starting_location = Enum.find(map, &(&1.type == "S"))
    first_step_location = make_step(starting_location, first_step_direction)

    first_step = Enum.find(map, &(&1.x == first_step_location.x && &1.y == first_step_location.y))

    move(first_step, first_step_direction, 1, map)
  end

  def move(%{type: "S"}, _, number_of_steps, _), do: number_of_steps

  def move(point, previous_direction, number_of_steps, map) do
    direction = choose_direction(point.type, previous_direction)

    new_location = make_step(point, direction)
    new_point = Enum.find(map, &(&1.x == new_location.x && &1.y == new_location.y))

    move(new_point, direction, number_of_steps + 1, map)
  end

  def make_step(point, direction) do
    case direction do
      :NORTH -> %{x: point.x, y: point.y - 1}
      :SOUTH -> %{x: point.x, y: point.y + 1}
      :EAST -> %{x: point.x + 1, y: point.y}
      :WEST -> %{x: point.x - 1, y: point.y}
    end
  end

  def choose_direction(pipe, previous_direction)

  def choose_direction("-", :EAST), do: :EAST
  def choose_direction("-", :WEST), do: :WEST

  def choose_direction("|", :SOUTH), do: :SOUTH
  def choose_direction("|", :NORTH), do: :NORTH

  def choose_direction("L", :WEST), do: :NORTH
  def choose_direction("L", :SOUTH), do: :EAST

  def choose_direction("J", :SOUTH), do: :WEST
  def choose_direction("J", :EAST), do: :NORTH

  def choose_direction("7", :EAST), do: :SOUTH
  def choose_direction("7", :NORTH), do: :WEST

  def choose_direction("F", :NORTH), do: :EAST
  def choose_direction("F", :WEST), do: :SOUTH

  def build_map(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.trim()
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {char, x} ->
        if char == ".", do: nil, else: %{x: x, y: y, type: char}
      end)
      |> Enum.reject(&is_nil/1)
    end)
  end

  defp example do
    "-L|F7
7S-7|
L|7||
-L-J|
L|-JF"
  end

  defp load do
    Api.get_input(10) |> String.trim()
  end
end
