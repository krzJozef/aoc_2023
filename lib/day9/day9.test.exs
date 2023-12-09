defmodule Day9Test do
  use ExUnit.Case

  alias Day9, as: Subject

  test "extrapolate" do
    assert [3, 15] == Subject.extrapolate([0, 3, 6, 9, 12, 15])
    assert [1, 6, 21] == Subject.extrapolate([1, 3, 6, 10, 15, 21])

    assert [2, 6, 15, 45] ==
             Subject.extrapolate([10, 13, 16, 21, 30, 45])
  end

  test "get_differences" do
    assert [3, 3, 3, 3, 3] = Subject.get_differences([0, 3, 6, 9, 12, 15])
    assert [0, 0, 0, 0] = Subject.get_differences([3, 3, 3, 3, 3])

    assert [2, 3, 4, 5, 6] = Subject.get_differences([1, 3, 6, 10, 15, 21])
    assert [1, 1, 1, 1] = Subject.get_differences([2, 3, 4, 5, 6])
    assert [0, 0, 0] = Subject.get_differences([1, 1, 1, 1])

    assert [3, 3, 5, 9, 15] = Subject.get_differences([10, 13, 16, 21, 30, 45])
    assert [0, 2, 4, 6] = Subject.get_differences([3, 3, 5, 9, 15])
    assert [2, 2, 2] = Subject.get_differences([0, 2, 4, 6])
    assert [0, 0] = Subject.get_differences([2, 2, 2])
  end

  test "calculate_last_number" do
    assert 18 == Subject.calculate_last_number([0, 3, 15])
    assert 28 == Subject.calculate_last_number([0, 1, 6, 21])
    assert 68 == Subject.calculate_last_number([0, 2, 6, 15, 45])
  end

  defp data do
    "0 3 6 9 12 15
   1 3 6 10 15 21
   10 13 16 21 30 45"
  end
end
