defmodule Day10Test do
  use ExUnit.Case

  alias Day10, as: Subject

  test "build_map" do
    assert [
             %{x: 2, y: 0, type: "F"},
             %{x: 3, y: 0, type: "7"},
             %{x: 1, y: 1, type: "F"},
             %{x: 2, y: 1, type: "J"},
             %{x: 3, y: 1, type: "|"},
             %{x: 0, y: 2, type: "S"},
             %{x: 1, y: 2, type: "J"},
             %{x: 3, y: 2, type: "L"},
             %{x: 4, y: 2, type: "7"},
             %{x: 0, y: 3, type: "|"},
             %{x: 1, y: 3, type: "F"},
             %{x: 2, y: 3, type: "-"},
             %{x: 3, y: 3, type: "-"},
             %{x: 4, y: 3, type: "J"},
             %{x: 0, y: 4, type: "L"},
             %{x: 1, y: 4, type: "J"}
           ] == Subject.build_map(data())
  end

  test "choose_direction" do
    assert :WEST == Subject.choose_direction("-", :EAST)
    assert :EAST == Subject.choose_direction("-", :WEST)
    assert :NORTH == Subject.choose_direction("|", :SOUTH)
    assert :SOUTH == Subject.choose_direction("|", :NORTH)

    assert :NORTH == Subject.choose_direction("L", :EAST)
    assert :EAST == Subject.choose_direction("L", :NORTH)

    assert :WEST == Subject.choose_direction("J", :NORTH)
    assert :NORTH == Subject.choose_direction("J", :WEST)

    assert :SOUTH == Subject.choose_direction("7", :WEST)
    assert :WEST == Subject.choose_direction("7", :SOUTH)
    assert :EAST == Subject.choose_direction("F", :SOUTH)
    assert :SOUTH == Subject.choose_direction("F", :EAST)
  end

  test "make_step" do
    assert %{x: 0, y: 3} = Subject.make_step(%{x: 0, y: 2}, :SOUTH)
    assert %{x: 0, y: 1} = Subject.make_step(%{x: 0, y: 2}, :NORTH)
    assert %{x: 1, y: 2} = Subject.make_step(%{x: 0, y: 2}, :EAST)
    assert %{x: 0, y: 2} = Subject.make_step(%{x: 1, y: 2}, :WEST)
  end

  test "calculate_loop_size" do
    map = [
      %{x: 2, y: 0, type: "F"},
      %{x: 3, y: 0, type: "7"},
      %{x: 1, y: 1, type: "F"},
      %{x: 2, y: 1, type: "J"},
      %{x: 3, y: 1, type: "|"},
      %{x: 0, y: 2, type: "S"},
      %{x: 1, y: 2, type: "J"},
      %{x: 3, y: 2, type: "L"},
      %{x: 4, y: 2, type: "7"},
      %{x: 0, y: 3, type: "|"},
      %{x: 1, y: 3, type: "F"},
      %{x: 2, y: 3, type: "-"},
      %{x: 3, y: 3, type: "-"},
      %{x: 4, y: 3, type: "J"},
      %{x: 0, y: 4, type: "L"},
      %{x: 1, y: 4, type: "J"}
    ]

    assert 16 == Subject.calculate_loop_size(map, :SOUTH)
  end

  defp data do
    "..F7.
     .FJ|.
     SJ.L7
     |F--J
     LJ..."
  end
end
