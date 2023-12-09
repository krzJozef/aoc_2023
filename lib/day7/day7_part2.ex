defmodule Day7.Part2 do
  @cards_values %{
    "J" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "T" => 10,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }

  def call do
    # data = example()
    data = load()
    games = load_games(data)
    sorted_games = sort_hands_asc(games)

    sorted_games
    |> Enum.with_index()
    |> Enum.map(fn {hand, index} ->
      hand.bid * (index + 1)
    end)
    |> Enum.sum()
  end

  def sort_hands_asc(data) do
    data
    |> Enum.map(fn hand ->
      Map.put(hand, :type_points, type_points(hand.cards))
    end)
    |> Enum.sort(&cards_sorter/2)
  end

  def cards_sorter(a, b) do
    cond do
      a.type_points < b.type_points ->
        true

      a.type_points > b.type_points ->
        false

      true ->
        cards_asc_sorter(a.cards, b.cards)
    end
  end

  def cards_asc_sorter(a, b) do
    left = String.split(a, "", trim: true) |> Enum.with_index()
    right = String.split(b, "", trim: true)

    Enum.reduce_while(left, nil, fn {card, index}, acc ->
      left_value = @cards_values[card]
      right_value = @cards_values[Enum.at(right, index)]

      cond do
        left_value < right_value ->
          {:halt, true}

        left_value > right_value ->
          {:halt, false}

        true ->
          {:cont, acc}
      end
    end)
  end

  def type_points(hand) do
    hand_enum = String.split(hand, "", trim: true)

    frequencies =
      hand_enum
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.sort()

    if String.contains?(hand, "J") do
      number_of_jokers = Enum.count(hand_enum, &(&1 == "J"))

      frequencies
      |> remove_jokers(number_of_jokers)
      |> boost_best(number_of_jokers)
      |> Enum.sort()
      |> IO.inspect(charlists: :as_lists)
      |> case do
        [5] -> 7
        [1, 4] -> 6
        [2, 3] -> 5
        [1, 1, 3] -> 4
        [1, 2, 2] -> 3
        [1, 1, 1, 2] -> 2
        [1, 1, 1, 1, 1] -> 1
      end
    else
      case frequencies do
        [5] -> 7
        [1, 4] -> 6
        [2, 3] -> 5
        [1, 1, 3] -> 4
        [1, 2, 2] -> 3
        [1, 1, 1, 2] -> 2
        [1, 1, 1, 1, 1] -> 1
      end
    end
  end

  def remove_jokers(list, 5), do: list

  def remove_jokers(list, number_of_jokers) do
    index = Enum.find_index(list, &(&1 == number_of_jokers))
    List.delete_at(list, index)
  end

  def boost_best(list, 5), do: list

  def boost_best(list, number_of_jokers) do
    best = Enum.max(list)
    index = Enum.find_index(list, &(&1 == best))

    List.replace_at(list, index, best + number_of_jokers)
  end

  def load_games(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [cards, bid] = String.split(line, " ", trim: true)

      %{cards: cards, bid: String.to_integer(bid)}
    end)
  end

  defp example do
    "32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483"
  end

  defp load do
    Api.get_input(7) |> String.trim()
  end
end
