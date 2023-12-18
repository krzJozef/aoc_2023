# 1091 -> too high

defmodule Day17.Part2 do
  use Memoize
  # node = {heat_loss, x, y, direction, same_direction_counter}
  def call(type \\ :example) do
    grid =
      type
      |> load()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    start = {0, 0, 0, nil, 0}

    {:ok, pq} = :epqueue.new([])

    loop(start, [], pq, grid)
  end

  def loop(current_node, visited, noted, grid) do
    IO.inspect(current_node)

    {current_heat_loss, current_x, current_y, current_direction, current_same_direction_counter} =
      current_node

    if current_x == length(Enum.at(grid, 0)) - 1 and current_y == length(grid) - 1 and
         current_same_direction_counter >= 4 do
      # We're at the end
      current_heat_loss
    else
      if {current_x, current_y, current_direction, current_same_direction_counter} in visited do
        {:ok, next_node, _} = :epqueue.pop(noted)

        loop(next_node, visited, noted, grid)
      else
        visited = [
          {current_x, current_y, current_direction, current_same_direction_counter} | visited
        ]

        neighbours =
          cond do
            {0, 0, 0, nil, 0} == current_node ->
              # We're at the starting point
              [
                {fetch_heat_loss(grid, 1, 0), 1, 0, :R, 1},
                {fetch_heat_loss(grid, 0, 1), 0, 1, :D, 1}
              ]

            current_same_direction_counter < 4 ->
              [
                same_direction_neighbour(
                  current_x,
                  current_y,
                  current_direction,
                  current_same_direction_counter,
                  grid
                )
              ]
              |> Enum.reject(&is_nil/1)

            current_same_direction_counter < 10 ->
              # jednego prosto i na boki, sprawdzić, zeby nie wypadaly poza mape
              [
                same_direction_neighbour(
                  current_x,
                  current_y,
                  current_direction,
                  current_same_direction_counter,
                  grid
                ),
                side_neighbours(current_x, current_y, current_direction, grid)
              ]
              |> List.flatten()
              |> Enum.reject(&is_nil/1)

            true ->
              side_neighbours(current_x, current_y, current_direction, grid)
              |> Enum.reject(&is_nil/1)
          end

        Enum.each(neighbours, fn {n_hl, n_x, n_y, n_cd, n_csdc} = _neighbour ->
          :epqueue.insert(
            noted,
            {n_hl + current_heat_loss, n_x, n_y, n_cd, n_csdc},
            n_hl + current_heat_loss
          )
        end)

        {:ok, next_node, _} = :epqueue.pop(noted)

        loop(next_node, visited, noted, grid)
      end
    end
  end

  defp same_direction_neighbour(x, y, :U, sdc, grid) do
    y = y - 1

    if y >= 0 do
      {fetch_heat_loss(grid, x, y), x, y, :U, sdc + 1}
    end
  end

  defp same_direction_neighbour(x, y, :D, sdc, grid) do
    y = y + 1

    if y < length(grid) do
      {fetch_heat_loss(grid, x, y), x, y, :D, sdc + 1}
    end
  end

  defp same_direction_neighbour(x, y, :L, sdc, grid) do
    x = x - 1

    if x >= 0 do
      {fetch_heat_loss(grid, x, y), x, y, :L, sdc + 1}
    end
  end

  defp same_direction_neighbour(x, y, :R, sdc, grid) do
    x = x + 1

    if x < Enum.at(grid, 0) |> length() do
      {fetch_heat_loss(grid, x, y), x, y, :R, sdc + 1}
    end
  end

  defp side_neighbours(x, y, d, grid) when d in [:U, :D] do
    left_x = x - 1

    left =
      if left_x >= 0 do
        {fetch_heat_loss(grid, left_x, y), left_x, y, :L, 1}
      end

    right_x = x + 1

    right =
      if right_x < Enum.at(grid, 0) |> length() do
        {fetch_heat_loss(grid, right_x, y), right_x, y, :R, 1}
      end

    [left, right]
  end

  defp side_neighbours(x, y, d, grid) when d in [:R, :L] do
    up_y = y - 1

    up =
      if up_y >= 0 do
        {fetch_heat_loss(grid, x, up_y), x, up_y, :U, 1}
      end

    down_y = y + 1

    down =
      if down_y < length(grid) do
        {fetch_heat_loss(grid, x, down_y), x, down_y, :D, 1}
      end

    [up, down]
  end

  defmemo fetch_heat_loss(grid, x, y), expire_in: :timer.hours(1) do
    grid
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def load(:example) do
    File.read!("lib/day17/example.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(17) |> String.trim()
end
