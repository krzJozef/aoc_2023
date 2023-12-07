defmodule Day7Test do
  use ExUnit.Case

  alias Day7, as: Subject

  test "type_points" do
    assert 2 == Subject.type_points("32T3K")
    assert 4 == Subject.type_points("T55J5")
    assert 3 == Subject.type_points("KK677")
    assert 3 == Subject.type_points("KTJJT")
    assert 4 == Subject.type_points("QQQJA")

    assert 5 == Subject.type_points("QQQAA")
    assert 6 == Subject.type_points("QQQQA")
    assert 7 == Subject.type_points("QQQQQ")
  end

  test "sort_hands_asc" do
    data = [
      %{cards: "T55J5", bid: 684},
      %{cards: "KTJJT", bid: 220},
      %{cards: "KK677", bid: 28},
      %{cards: "QQQJA", bid: 483},
      %{cards: "32T3K", bid: 765}
    ]

    assert [
             %{cards: "32T3K", type_points: 2, bid: 765},
             %{cards: "KTJJT", type_points: 3, bid: 220},
             %{cards: "KK677", type_points: 3, bid: 28},
             %{cards: "T55J5", type_points: 4, bid: 684},
             %{cards: "QQQJA", type_points: 4, bid: 483}
           ] == Subject.sort_hands_asc(data)
  end

  test "load_games" do
    assert [
             %{cards: "32T3K", bid: 765},
             %{cards: "T55J5", bid: 684},
             %{cards: "KK677", bid: 28},
             %{cards: "KTJJT", bid: 220},
             %{cards: "QQQJA", bid: 483}
           ] == Subject.load_games(data())
  end

  test "cards_asc_sorter" do
    assert false == Subject.cards_asc_sorter("A2222", "22222")
    assert false == Subject.cards_asc_sorter("AAAA3", "AAAA2")
    assert true == Subject.cards_asc_sorter("AAAA2", "AAAA3")
  end

  defp data do
    "32T3K 765
   T55J5 684
   KK677 28
   KTJJT 220
   QQQJA 483"
  end
end
