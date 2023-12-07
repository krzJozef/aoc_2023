defmodule Day6Test do
  use ExUnit.Case

  alias Day6.Part2, as: Subject

  test "get_number_of_seconds_that_win" do
    race_data = %{
      time: 7,
      distance: 9
    }

    assert [2, 3, 4, 5] == Subject.get_number_of_seconds_that_win(race_data)
  end

  test "calculate_distance" do
    total_time = 7

    assert 0 == Subject.calculate_distance(0, total_time)
    assert 6 == Subject.calculate_distance(1, total_time)
    assert 10 == Subject.calculate_distance(2, total_time)
    assert 12 == Subject.calculate_distance(3, total_time)
    assert 12 == Subject.calculate_distance(4, total_time)
    assert 10 == Subject.calculate_distance(5, total_time)
    assert 6 == Subject.calculate_distance(6, total_time)
  end

  test "load_races" do
    assert %{
             time: 71530,
             distance: 940_200
           } == Subject.load_races(data())
  end

  defp data do
    "Time:      7  15   30
    Distance:  9  40  200"
  end
end
