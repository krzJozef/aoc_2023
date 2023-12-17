defmodule Day17.Test do
  use ExUnit.Case

  alias Day17, as: Subject

  test "dijkstra" do
    graph = %{
      "A" => [{"B", 2}, {"D", 8}],
      "B" => [{"A", 2}, {"D", 5}, {"E", 6}],
      "C" => [{"E", 9}, {"F", 3}],
      "D" => [{"A", 8}, {"B", 5}, {"E", 3}, {"F", 2}],
      "E" => [{"B", 6}, {"D", 3}, {"F", 1}, {"C", 9}],
      "F" => [{"D", 2}, {"E", 1}, {"C", 3}]
    }

    assert 12 == Subject.dijkstra(graph, "A", "C")
  end
end
