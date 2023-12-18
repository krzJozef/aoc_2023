defmodule Day17 do
  def call(type \\ :example) do
    data = load(type)

    grid =
      data
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    IO.inspect(length(grid), label: "GRID")

    heap = [
      %{heat_loss: 0, x: 0, y: 0, direction_x: 0, direction_y: 0, same_direction_counter: 0}
    ]

    visited = []

    loop(heap, grid, visited)
  end

  def loop([%{x: 140, y: 140, heat_loss: heat_loss} | _tail], _grid, _visited), do: heat_loss

  def loop(heap, grid, visited) do
    node = List.first(heap)

    if !Enum.find(visited, fn v ->
         v.x == node.x and v.y == node.y and v.direction_x == node.direction_x and
           v.direction_y == node.direction_y and
           v.same_direction_counter == node.same_direction_counter
       end) do
      visited = [node | visited]

      %{
        heat_loss: current_heat_loss,
        x: x,
        y: y,
        direction_x: direction_x,
        direction_y: direction_y,
        same_direction_counter: same_direction_counter
      } = node

      # sąsiedzi w jednym kierunku
      new_neighbours =
        if same_direction_counter < 3 and (direction_x != 0 or direction_y != 0) do
          next_x = x + direction_x
          next_y = y + direction_y

          if next_x >= 0 and next_x < length(grid) and next_y >= 0 and next_y < length(grid) do
            [
              %{
                heat_loss: current_heat_loss + (grid |> Enum.at(next_y) |> Enum.at(next_x)),
                x: next_x,
                y: next_y,
                direction_x: direction_x,
                direction_y: direction_y,
                same_direction_counter: same_direction_counter + 1
              }
            ]
          else
            []
          end
        else
          []
        end

      # sąsiedzi w pozostałych kierunkach
      new_neighbours =
        (new_neighbours ++
           Enum.map([{1, 0}, {-1, 0}, {0, 1}, {0, -1}], fn {new_direction_x, new_direction_y} =
                                                             new_direction ->
             if !does_continue_direction(
                  new_direction,
                  direction_x,
                  direction_y
                ) and
                  !is_opposite(new_direction, direction_x, direction_y) do
               next_x = x + new_direction_x
               next_y = y + new_direction_y

               if next_x >= 0 and next_x < length(grid) and next_y >= 0 and next_y < length(grid) do
                 %{
                   heat_loss: current_heat_loss + (grid |> Enum.at(next_y) |> Enum.at(next_x)),
                   x: next_x,
                   y: next_y,
                   direction_x: new_direction_x,
                   direction_y: new_direction_y,
                   same_direction_counter: 1
                 }
               else
                 nil
               end
             else
               nil
             end
           end))
        |> Enum.reject(&is_nil/1)

      new_heap =
        case heap do
          [] -> new_neighbours
          [_ | tail] -> new_neighbours ++ tail
        end
        |> Enum.uniq()
        |> Enum.sort_by(& &1.heat_loss, :asc)

      loop(new_heap, grid, visited)
    else
      [_ | tail] = heap

      tail
      |> Enum.sort_by(& &1.heat_loss, :asc)
      |> loop(grid, visited)
    end
  end

  defp does_continue_direction(new_direction, direction_x, direction_y) do
    new_direction == {direction_x, direction_y}
  end

  defp is_opposite(new_direction, direction_x, direction_y) do
    new_direction == {-direction_x, -direction_y}
  end

  def load(:example) do
    File.read!("lib/day17/example.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(17) |> String.trim()
end
