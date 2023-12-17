defmodule Day17 do
  def call(type \\ :example) do
    _data = load(type)
  end

  def dijkstra(graph, start_node, end_node) do
    visited_nodes = []
    unvisited_nodes = Map.keys(graph)
    history = [{start_node, 0, nil}]

    history = do_dijkstra(start_node, graph, history, visited_nodes, unvisited_nodes)

    history |> Enum.find(&(elem(&1, 0) == end_node)) |> elem(1)
  end

  defp do_dijkstra(_node, _graph, history, _visited, []), do: history

  defp do_dijkstra(node, graph, history, visited, unvisited) do
    visited = [node | visited]
    unvisited = unvisited -- [node]

    neighbours = graph[node] |> IO.inspect(label: "NEIGHBOURS")
    history = update_history(history, neighbours, node)

    history
    |> Enum.reject(&(elem(&1, 0) in visited))
    |> case do
      [] ->
        history

      list ->
        next_node =
          list
          |> Enum.sort_by(&elem(&1, 1), :asc)
          |> Enum.at(0)
          |> IO.inspect(label: "NEXT CANDIDATE")
          |> elem(0)

        do_dijkstra(next_node, graph, history, visited, unvisited)
    end
  end

  defp update_history(history, neighbours, current_node) do
    current_node_distance = elem(Enum.find(history, &(elem(&1, 0) == current_node)), 1)

    Enum.reduce(neighbours, history, fn {node, distance}, history_acc ->
      case Enum.find(history_acc, &(elem(&1, 0) == node)) do
        nil ->
          [{node, distance + current_node_distance, current_node} | history_acc]

        {node, previous_distance, _previous_node}
        when previous_distance > distance + current_node_distance ->
          history_acc
          |> Enum.reject(&(elem(&1, 0) == node))
          |> List.insert_at(0, {node, distance + current_node_distance, current_node})

        # [{node, distance + current_node_distance, current_node} | history_acc]

        _ ->
          history_acc
      end
    end)
  end

  defp load(:example) do
    File.read!("lib/day17/example.txt") |> String.trim()
  end

  defp load(:input), do: Api.get_input(17) |> String.trim()
end
