defmodule Day4.Part2 do
  def call do
    # load_example()
    # load_example()
    # load_example()
    card_deck =
      load()
      |> String.split("\n", trim: true)
      |> Enum.map(fn card_string ->
        card_string = String.trim(card_string)
        ["Card " <> id, _card_string] = String.split(card_string, ":", trim: true)

        %{
          id: id |> String.trim() |> String.to_integer(),
          card_string: card_string,
          number_of_copies: 1
        }
      end)

    Enum.reduce(card_deck, card_deck, fn card, acc ->
      current_card = Enum.find(acc, fn c -> c.id == card.id end)

      winning_numbers = get_winning_numbers(card.card_string)
      playing_numbers = get_playing_numbers(card.card_string)

      how_many_winnings = check_winning_numbers(playing_numbers, winning_numbers)

      if how_many_winnings == 0 do
        acc
      else
        ids_of_copies =
          Enum.map(1..how_many_winnings, fn n -> card.id + n end)

        Enum.map(acc, fn card ->
          if card.id in ids_of_copies do
            %{
              id: card.id,
              card_string: card.card_string,
              number_of_copies: card.number_of_copies + 1 * current_card.number_of_copies
            }
          else
            card
          end
        end)
      end
    end)
    |> Enum.map(& &1.number_of_copies)
    |> Enum.sum()
  end

  def get_winning_numbers(card) do
    [first_part, _] = String.split(card, "|", trim: true)
    [_, numbers_string] = String.split(first_part, ":", trim: true)

    numbers_string
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def get_playing_numbers(card) do
    [_, second_part] = String.split(card, "|", trim: true)

    second_part
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def check_winning_numbers(all_numbers, winning_numbers) do
    Enum.count(all_numbers, &(&1 in winning_numbers))
  end

  def load_example do
    "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
   Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
   Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
   Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
   Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
   Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
    |> String.trim()
  end

  def load do
    Api.get_input(4) |> String.trim()
  end
end
