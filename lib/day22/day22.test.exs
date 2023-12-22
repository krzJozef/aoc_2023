defmodule Day22Test do
  use ExUnit.Case

  alias Day22, as: Subject

  describe "supported_bricks" do
    test "when there is none" do
      assert [] =
               Subject.supported_bricks(
                 [%{y: 1, x: 1, z: 5}, %{y: 1, x: 1, z: 6}],
                 stack_of_bricks()
               )
    end

    test "when there is one" do
      assert [
               [%{y: 1, x: 1, z: 5}, %{y: 1, x: 1, z: 6}]
             ] =
               Subject.supported_bricks(
                 [%{y: 1, x: 0, z: 4}, %{y: 1, x: 2, z: 4}],
                 stack_of_bricks()
               )
    end

    test "when there are many" do
      assert [
               [%{y: 2, x: 0, z: 2}, %{y: 2, x: 2, z: 2}],
               [%{y: 0, x: 0, z: 2}, %{y: 0, x: 2, z: 2}]
             ] =
               Subject.supported_bricks(
                 [%{y: 0, x: 1, z: 1}, %{y: 2, x: 1, z: 1}],
                 stack_of_bricks()
               )
    end
  end

  describe "number_of_supporting_bricks" do
    test "when there is one" do
      assert 1 ==
               Subject.number_of_supporting_bricks(
                 [%{y: 0, x: 0, z: 2}, %{y: 0, x: 2, z: 2}],
                 stack_of_bricks()
               )

      assert 1 ==
               Subject.number_of_supporting_bricks(
                 [%{y: 2, x: 0, z: 2}, %{y: 2, x: 2, z: 2}],
                 stack_of_bricks()
               )
    end

    test "when there are many" do
      assert 2 ==
               Subject.number_of_supporting_bricks(
                 [%{y: 0, x: 0, z: 3}, %{y: 2, x: 0, z: 3}],
                 stack_of_bricks()
               )

      assert 2 ==
               Subject.number_of_supporting_bricks(
                 [%{y: 0, x: 2, z: 3}, %{y: 2, x: 2, z: 3}],
                 stack_of_bricks()
               )

      assert 2 ==
               Subject.number_of_supporting_bricks(
                 [%{y: 1, x: 0, z: 4}, %{y: 1, x: 2, z: 4}],
                 stack_of_bricks()
               )
    end
  end

  defp stack_of_bricks do
    [
      [%{y: 1, x: 1, z: 5}, %{y: 1, x: 1, z: 6}],
      [%{y: 1, x: 0, z: 4}, %{y: 1, x: 2, z: 4}],
      [%{y: 0, x: 2, z: 3}, %{y: 2, x: 2, z: 3}],
      [%{y: 0, x: 0, z: 3}, %{y: 2, x: 0, z: 3}],
      [%{y: 2, x: 0, z: 2}, %{y: 2, x: 2, z: 2}],
      [%{y: 0, x: 0, z: 2}, %{y: 0, x: 2, z: 2}],
      [%{y: 0, x: 1, z: 1}, %{y: 2, x: 1, z: 1}]
    ]
  end
end
