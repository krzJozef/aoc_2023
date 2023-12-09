defmodule Day8Test do
  use ExUnit.Case

  alias Day8, as: Subject

  test "generate_map" do
    assert %{
             "AAA" => ["BBB", "CCC"],
             "BBB" => ["DDD", "EEE"],
             "CCC" => ["ZZZ", "GGG"],
             "DDD" => ["DDD", "DDD"],
             "EEE" => ["EEE", "EEE"],
             "GGG" => ["GGG", "GGG"],
             "ZZZ" => ["ZZZ", "ZZZ"]
           } = Subject.generate_map(data1())
  end

  test "make_move" do
    map = %{
      "AAA" => ["BBB", "CCC"],
      "BBB" => ["DDD", "EEE"],
      "CCC" => ["ZZZ", "GGG"],
      "DDD" => ["DDD", "DDD"],
      "EEE" => ["EEE", "EEE"],
      "GGG" => ["GGG", "GGG"],
      "ZZZ" => ["ZZZ", "ZZZ"]
    }

    assert "CCC" = Subject.make_move("AAA", "R", map)
    assert "ZZZ" = Subject.make_move("CCC", "L", map)
  end

  test "next_direction" do
    pattern = "RL"

    assert "R" == Subject.next_direction(pattern, 1)
    assert "L" == Subject.next_direction(pattern, 2)
    assert "R" == Subject.next_direction(pattern, 3)
    assert "L" == Subject.next_direction(pattern, 4)

    pattern = "LLR"

    assert "L" == Subject.next_direction(pattern, 1)
    assert "L" == Subject.next_direction(pattern, 2)
    assert "R" == Subject.next_direction(pattern, 3)
    assert "L" == Subject.next_direction(pattern, 4)
    assert "L" == Subject.next_direction(pattern, 5)
    assert "R" == Subject.next_direction(pattern, 6)
  end

  defp data1 do
    "RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)"
  end
end
