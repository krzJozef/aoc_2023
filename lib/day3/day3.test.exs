defmodule Day3Test do
  use ExUnit.Case

  describe "number_coordinates" do
    test "example" do
      assert MapSet.equal?(
               MapSet.new([
                 [467, {0, 0}, {0, 1}, {0, 2}],
                 [114, {0, 5}, {0, 6}, {0, 7}],
                 [35, {2, 2}, {2, 3}],
                 [633, {2, 6}, {2, 7}, {2, 8}],
                 [633, {4, 5}, {4, 6}, {4, 7}]
               ]),
               MapSet.new(Day3.number_coordinates(data()))
             )
    end
  end

  describe "symbol_coordinations" do
    test "example" do
      assert [{1, 3}, {3, 6}] = Day3.symbol_coordinations(data())
    end
  end

  describe "get_numbers_next_to_symbols" do
    test "example" do
      numbers_coordinations = [
        [467, {0, 0}, {0, 1}, {0, 2}],
        [114, {0, 5}, {0, 6}, {0, 7}],
        [35, {2, 2}, {2, 3}],
        [633, {2, 6}, {2, 7}, {2, 8}],
        [633, {4, 5}, {4, 6}, {4, 7}]
      ]

      symbols_coordinations = [{1, 3}, {3, 6}]

      assert MapSet.equal?(
               MapSet.new([467, 35, 633, 633]),
               MapSet.new(
                 Day3.get_numbers_next_to_symbols(numbers_coordinations, symbols_coordinations)
               )
             )
    end
  end

  defp data do
    "467..114..
    ...*......
    ..35..633.
    ......#...
    .....633.."
    |> String.trim()
  end
end
