defmodule Day15.Test do
  use ExUnit.Case

  alias Day15, as: Subject

  test "move_rocks" do
    assert "OOOO....##" == Subject.move_rocks("OO.O.O..##")
    assert "O....#OO.." = Subject.move_rocks(".O...#O..O")
  end

  test "calculate_line_score" do
    assert 33 == Subject.calculate_line_score("O....##OO..#O..")
  end

  defp data do
    "O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..r
    #OO..#...."
  end
end

"OOOO.#.O..
  OO..#....#
  OO..O##..O
  O..#.OO...
  ........#.
  ..#....#.#
  ..O..#.O.O
  ..O.......
  #....###..
  #....#....
"
