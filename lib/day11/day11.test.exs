defmodule Day11Test do
  use ExUnit.Case

  alias Day11, as: Subject

  test "calculate_distance" do
    assert 15 == Subject.calculate_distance([%{x: 4, y: 0}, %{x: 9, y: 10}])
    assert 9 == Subject.calculate_distance([%{x: 1, y: 6}, %{x: 5, y: 11}])
    assert 17 == Subject.calculate_distance([%{x: 0, y: 2}, %{x: 12, y: 7}])
    assert 5 == Subject.calculate_distance([%{x: 0, y: 11}, %{x: 5, y: 11}])
  end

  test "build_galaxy" do
    assert MapSet.equal?(
             MapSet.new([
               %{x: 3, y: 0},
               %{x: 7, y: 1},
               %{x: 0, y: 2},
               %{x: 6, y: 4},
               %{x: 1, y: 5},
               %{x: 9, y: 6},
               %{x: 7, y: 8},
               %{x: 0, y: 9},
               %{x: 4, y: 9}
             ]),
             MapSet.new(Subject.build_galaxy(data()))
           )
  end

  test "expand_galaxy" do
    galaxy = [
      %{x: 3, y: 0},
      %{x: 7, y: 1},
      %{x: 0, y: 2},
      %{x: 6, y: 4},
      %{x: 1, y: 5},
      %{x: 9, y: 6},
      %{x: 7, y: 8},
      %{x: 0, y: 9},
      %{x: 4, y: 9}
    ]

    assert MapSet.equal?(
             MapSet.new([
               %{x: 4, y: 0},
               %{x: 9, y: 1},
               %{x: 0, y: 2},
               %{x: 8, y: 5},
               %{x: 1, y: 6},
               %{x: 12, y: 7},
               %{x: 9, y: 10},
               %{x: 0, y: 11},
               %{x: 5, y: 11}
             ]),
             MapSet.new(Subject.expand_galaxy(galaxy))
           )
  end

  test "connect_in_pairs" do
    galaxy = [
      %{x: 4, y: 0},
      %{x: 9, y: 1},
      %{x: 0, y: 2},
      %{x: 8, y: 5},
      %{x: 1, y: 6},
      %{x: 12, y: 7},
      %{x: 9, y: 10},
      %{x: 0, y: 11},
      %{x: 5, y: 11}
    ]

    result = [
      [%{x: 4, y: 0}, %{x: 9, y: 1}],
      [%{x: 4, y: 0}, %{x: 0, y: 2}],
      [%{x: 4, y: 0}, %{x: 8, y: 5}],
      [%{x: 4, y: 0}, %{x: 1, y: 6}],
      [%{x: 4, y: 0}, %{x: 12, y: 7}],
      [%{x: 4, y: 0}, %{x: 9, y: 10}],
      [%{x: 4, y: 0}, %{x: 0, y: 11}],
      [%{x: 4, y: 0}, %{x: 5, y: 11}],
      [%{x: 9, y: 1}, %{x: 0, y: 2}],
      [%{x: 9, y: 1}, %{x: 8, y: 5}],
      [%{x: 9, y: 1}, %{x: 1, y: 6}],
      [%{x: 9, y: 1}, %{x: 12, y: 7}],
      [%{x: 9, y: 1}, %{x: 9, y: 10}],
      [%{x: 9, y: 1}, %{x: 0, y: 11}],
      [%{x: 9, y: 1}, %{x: 5, y: 11}],
      [%{x: 0, y: 2}, %{x: 8, y: 5}],
      [%{x: 0, y: 2}, %{x: 1, y: 6}],
      [%{x: 0, y: 2}, %{x: 12, y: 7}],
      [%{x: 0, y: 2}, %{x: 9, y: 10}],
      [%{x: 0, y: 2}, %{x: 0, y: 11}],
      [%{x: 0, y: 2}, %{x: 5, y: 11}],
      [%{x: 8, y: 5}, %{x: 1, y: 6}],
      [%{x: 8, y: 5}, %{x: 12, y: 7}],
      [%{x: 8, y: 5}, %{x: 9, y: 10}],
      [%{x: 8, y: 5}, %{x: 0, y: 11}],
      [%{x: 8, y: 5}, %{x: 5, y: 11}],
      [%{x: 1, y: 6}, %{x: 12, y: 7}],
      [%{x: 1, y: 6}, %{x: 9, y: 10}],
      [%{x: 1, y: 6}, %{x: 0, y: 11}],
      [%{x: 1, y: 6}, %{x: 5, y: 11}],
      [%{x: 12, y: 7}, %{x: 9, y: 10}],
      [%{x: 12, y: 7}, %{x: 0, y: 11}],
      [%{x: 12, y: 7}, %{x: 5, y: 11}],
      [%{x: 9, y: 10}, %{x: 0, y: 11}],
      [%{x: 9, y: 10}, %{x: 5, y: 11}],
      [%{x: 0, y: 11}, %{x: 5, y: 11}]
    ]

    assert MapSet.equal?(
             MapSet.new(result),
             MapSet.new(Subject.connect_in_pairs(galaxy))
           )
  end

  defp data do
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
end
