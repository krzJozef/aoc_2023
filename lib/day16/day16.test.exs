defmodule Day16.Test do
  use ExUnit.Case

  alias Day16, as: Subject

  test "make_step" do
    grid = grid()

    assert %{x: 1, y: 0, direction: :right} == Subject.make_step(0, 0, :right, grid)

    assert [:out, %{x: 1, y: 1, direction: :down}] = Subject.make_step(1, 0, :right, grid)

    assert %{x: 5, y: 1, direction: :down} = Subject.make_step(5, 0, :right, grid)
  end

  test "switch_direction" do
    assert :right == Subject.switch_direction(".", :right)
    assert :left == Subject.switch_direction(".", :left)
    assert :down == Subject.switch_direction(".", :down)
    assert :up == Subject.switch_direction(".", :up)

    assert [:up, :down] == Subject.switch_direction("|", :right)
    assert [:up, :down] == Subject.switch_direction("|", :left)
    assert :up == Subject.switch_direction("|", :up)
    assert :down == Subject.switch_direction("|", :down)

    assert :right == Subject.switch_direction("-", :right)
    assert :left == Subject.switch_direction("-", :left)
    assert [:left, :right] == Subject.switch_direction("-", :up)
    assert [:left, :right] == Subject.switch_direction("-", :down)

    assert :down == Subject.switch_direction("\\", :right)
    assert :up == Subject.switch_direction("\\", :left)
    assert :left == Subject.switch_direction("\\", :up)
    assert :right == Subject.switch_direction("\\", :down)

    assert :up == Subject.switch_direction("/", :right)
    assert :down == Subject.switch_direction("/", :left)
    assert :right == Subject.switch_direction("/", :up)
    assert :left == Subject.switch_direction("/", :down)
  end

  def grid do
    [
      [".", "|", ".", ".", ".", "\\", ".", ".", ".", "."],
      ["|", ".", "-", ".", "\\", ".", ".", ".", ".", "."],
      [".", ".", ".", ".", ".", "|", "-", ".", ".", "."],
      [".", ".", ".", ".", ".", ".", ".", ".", "|", "."],
      [".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
      [".", ".", ".", ".", ".", ".", ".", ".", ".", "\\"],
      [".", ".", ".", ".", "/", ".", "\\", "\\", ".", "."],
      [".", "-", ".", "-", "/", ".", ".", "|", ".", "."],
      [".", "|", ".", ".", ".", ".", "-", "|", ".", "\\"],
      [".", ".", "/", "/", ".", "|", ".", ".", ".", "."]
    ]
  end
end
