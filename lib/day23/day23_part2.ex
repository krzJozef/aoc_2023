defmodule Day23.Part2 do
  use Memoize

  def call(type \\ :example) do
    data = load(type)
    map = build_map(data)

    intersections = find_intersections(map)

    IO.puts("INTERSECTIONS FOUND")

    intersections_graph =
      Enum.map(intersections, fn intersection ->
        other_intersections = intersections -- [intersection]

        {intersection,
         Enum.map(other_intersections, fn oi ->
           %{node: oi, steps: dijkstra(intersection, oi, map, other_intersections)}
         end)
         |> Enum.reject(&(&1.steps == nil))}
      end)
      |> Enum.into(%{})

    IO.puts("INTERSECTIONS GRAPH CREATED")

    intersection_positions =
      intersections
      |> Enum.map(fn {x, y} = coordinates ->
        {coordinates, x * y}
      end)

    first_intersection = Enum.min_by(intersection_positions, &elem(&1, 1)) |> elem(0)
    last_intersection = Enum.max_by(intersection_positions, &elem(&1, 1)) |> elem(0)

    IO.puts("STARTING THE LOOP")

    paths_between_intersections(
      Tuple.append(first_intersection, 0),
      last_intersection,
      intersections_graph,
      []
    )
    |> List.flatten()
    |> Enum.max()

    # So this gives us the number of steps between the first and last intersection.
    # I manually added number of steps between the starting point to the first intersection and between the last intersection and the end point to it.
  end

  def paths_between_intersections(current_node, end_node, grid, visited) do
    {current_x, current_y, current_steps} = current_node
    {endpoint_x, endpoint_y} = end_node

    cond do
      current_x == endpoint_x and current_y == endpoint_y ->
        # we're at the end
        current_steps

      {current_x, current_y} in visited ->
        # we've been here before
        0

      true ->
        visited = [
          {current_x, current_y} | visited
        ]

        neighbours =
          grid[{current_x, current_y}]
          |> Enum.map(fn %{node: {x, y}, steps: steps} ->
            {x, y, steps + current_steps}
          end)

        Enum.map(neighbours, fn neighbour ->
          paths_between_intersections(neighbour, end_node, grid, visited)
        end)
    end
  end

  def find_intersections(map) do
    size = length(map) - 1

    Enum.reduce(0..size, [], fn current_y, acc ->
      in_line =
        Enum.reduce(0..size, [], fn current_x, acc ->
          element = map |> Enum.at(current_y) |> Enum.at(current_x)

          if element == "#" do
            acc
          else
            neighbours =
              [
                {current_x + 1, current_y},
                {current_x - 1, current_y},
                {current_x, current_y + 1},
                {current_x, current_y - 1}
              ]
              |> Enum.reject(fn {x, y} ->
                x < 0 or x > size or y < 0 or y > size or
                  Enum.at(map, y) |> Enum.at(x) == "#"
              end)

            if length(neighbours) > 2, do: [{current_x, current_y} | acc], else: acc
          end
        end)

      acc ++ in_line
    end)
  end

  def dijkstra({x, y}, endpoint, map, other_intersections) do
    start_node = %{x: x, y: y, steps: 0}

    do_dijkstra([start_node], [], endpoint, map, other_intersections)
  end

  def do_dijkstra([], _, _, _, _), do: nil

  def do_dijkstra([%{x: x, y: y, steps: steps} | _], _, {x, y}, _, _), do: steps

  def do_dijkstra(heap, visited, endpoint, map, other_intersections) do
    [current_node | heap] = heap

    cond do
      {current_node.x, current_node.y} in visited ->
        # already visited
        do_dijkstra(heap, visited, endpoint, map, other_intersections)

      {current_node.x, current_node.y} in other_intersections ->
        # don't care
        do_dijkstra(heap, visited, endpoint, map, other_intersections)

      true ->
        neighbours =
          [
            {current_node.x + 1, current_node.y},
            {current_node.x - 1, current_node.y},
            {current_node.x, current_node.y + 1},
            {current_node.x, current_node.y - 1}
          ]
          |> Enum.reject(fn {x, y} ->
            x < 0 or x >= length(map) or y < 0 or y >= length(map)
          end)
          |> Enum.map(fn {x, y} ->
            element = Enum.at(map, y) |> Enum.at(x)
            %{x: x, y: y, element: element, steps: current_node.steps + 1}
          end)
          |> Enum.reject(&(&1.element != "."))

        new_heap = (heap ++ neighbours) |> Enum.sort_by(& &1.steps, :asc)

        do_dijkstra(
          new_heap,
          [{current_node.x, current_node.y} | visited],
          endpoint,
          map,
          other_intersections
        )
    end
  end

  def build_map(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(fn
        char when char in ["<", ">", "^", "v"] ->
          "."

        char ->
          char
      end)
    end)
  end

  def load(:example) do
    File.read!("lib/day23/example.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(23) |> String.trim()
end
