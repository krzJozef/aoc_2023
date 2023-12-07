defmodule Day4.Part2Test do
  use ExUnit.Case

  alias Day4.Part2, as: Subject

  test "get_winning_numbers" do
    assert [41, 48, 83, 86, 17] ==
             Subject.get_winning_numbers("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")

    assert [13, 32, 20, 16, 61] ==
             Subject.get_winning_numbers("Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19")

    assert [1, 21, 53, 59, 44] ==
             Subject.get_winning_numbers("Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1")

    assert [41, 92, 73, 84, 69] ==
             Subject.get_winning_numbers("Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83")

    assert [87, 83, 26, 28, 32] ==
             Subject.get_winning_numbers("Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36")

    assert [31, 18, 13, 56, 72] ==
             Subject.get_winning_numbers("Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11")
  end

  test "get_playing_numbers" do
    assert [83, 86, 6, 31, 17, 9, 48, 53] ==
             Subject.get_playing_numbers("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")

    assert [61, 30, 68, 82, 17, 32, 24, 19] ==
             Subject.get_playing_numbers("Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19")

    assert [69, 82, 63, 72, 16, 21, 14, 1] ==
             Subject.get_playing_numbers("Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1")

    assert [74, 77, 10, 23, 35, 67, 36, 11] ==
             Subject.get_playing_numbers("Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11")
  end

  test "check_score" do
    assert 8 == Subject.check_score([83, 86, 6, 31, 17, 9, 48, 53], [41, 48, 83, 86, 17])
  end
end
