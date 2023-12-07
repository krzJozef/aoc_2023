defmodule Day3.Part2Test do
  use ExUnit.Case

  alias Day3.Part2, as: Subject

  describe "number_coordinates" do
    test "example" do
      assert MapSet.equal?(
               MapSet.new([
                 [467, {0, 0}, {0, 1}, {0, 2}],
                 [114, {0, 5}, {0, 6}, {0, 7}],
                 [35, {2, 2}, {2, 3}],
                 [633, {2, 6}, {2, 7}, {2, 8}],
                 [633, {4, 5}, {4, 6}, {4, 7}],
                 [617, {5, 0}, {5, 1}, {5, 2}],
                 [58, {6, 7}, {6, 8}],
                 [592, {7, 2}, {7, 3}, {7, 4}],
                 [755, {8, 6}, {8, 7}, {8, 8}],
                 [664, {10, 1}, {10, 2}, {10, 3}],
                 [598, {10, 5}, {10, 6}, {10, 7}]
               ]),
               MapSet.new(Subject.number_coordinates(data()))
             )
    end
  end

  describe "symbol_coordinations" do
    test "example" do
      assert [{1, 3}, {5, 3}, {9, 5}] = Subject.symbol_coordinations(data())
    end
  end

  describe "get_numbers_next_to_symbols" do
    test "example" do
      numbers_coordinations = [
        [467, {0, 0}, {0, 1}, {0, 2}],
        [114, {0, 5}, {0, 6}, {0, 7}],
        [35, {2, 2}, {2, 3}],
        [633, {2, 6}, {2, 7}, {2, 8}],
        [633, {4, 5}, {4, 6}, {4, 7}],
        [617, {5, 0}, {5, 1}, {5, 2}],
        [58, {6, 7}, {6, 8}],
        [592, {7, 2}, {7, 3}, {7, 4}],
        [755, {8, 6}, {8, 7}, {8, 8}],
        [664, {10, 1}, {10, 2}, {10, 3}],
        [598, {10, 5}, {10, 6}, {10, 7}]
      ]

      symbols_coordinations = [{1, 3}, {5, 3}, {9, 5}]

      assert MapSet.equal?(
               MapSet.new([16345, 451_490]),
               MapSet.new(
                 Subject.get_numbers_next_to_symbols(numbers_coordinations, symbols_coordinations)
               )
             )
    end
  end

  defp data do
    "467..114..
    ...*......
    ..35..633.
    ......#...
    .....633..
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598.."
    |> String.trim()
  end
end
