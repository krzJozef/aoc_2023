defmodule Day12.Part2Test do
  use ExUnit.Case

  alias Day12.Part2, as: Subject

  test "unfold" do
    assert ".#?.#?.#?.#?.# 1,1,1,1,1" == Subject.unfold(".# 1")

    assert "???.###????.###????.###????.###????.### 1,1,3,1,1,3,1,1,3,1,1,3,1,1,3" ==
             Subject.unfold("???.### 1,1,3")
  end

  test "is_correct" do
    assert Subject.is_correct("#.#.###", [1, 1, 3])
    assert Subject.is_correct(".#...#....###.", [1, 1, 3])
    assert Subject.is_correct(".#.###.#.######", [1, 3, 1, 6])
    assert Subject.is_correct("####.#...#...", [4, 1, 1])
    assert Subject.is_correct("#....######..#####.", [1, 6, 5])
    assert Subject.is_correct(".###.##....#", [3, 2, 1])

    refute Subject.is_correct(".#..###", [1, 1, 3])
    refute Subject.is_correct(".#.......####.", [1, 1, 3])
    refute Subject.is_correct(".#.###.#..#####", [1, 3, 1, 6])
    refute Subject.is_correct("####.#.......", [4, 1, 1])
    refute Subject.is_correct("#...#######..#####.", [1, 6, 5])
    refute Subject.is_correct(".#####....#", [3, 2, 1])
  end

  test "generate_all_possibilities" do
    assert MapSet.equal?(
             MapSet.new([
               "....###",
               "..#.###",
               ".#..###",
               ".##.###",
               "###.###",
               "#...###",
               "#.#.###",
               "##..###",
               "###.###"
             ]),
             MapSet.new(Subject.generate_all_possibilities("???.###"))
           )
  end

  defp data do
    "???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1"
  end
end
