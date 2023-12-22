defmodule Day22 do
  def call(type \\ :example) do
    data = load(type)

    bricks = load_bricks(data)

    stack_of_bricks = fall_bricks(bricks)

    Enum.count(stack_of_bricks, fn brick ->
      can_be_disintegrated?(brick, stack_of_bricks)
    end)
  end

  def can_be_disintegrated?(brick, stack_of_bricks) do
    brick
    |> supported_bricks(stack_of_bricks)
    |> case do
      [] ->
        true

      supported_bricks ->
        Enum.all?(supported_bricks, &(number_of_supporting_bricks(&1, stack_of_bricks) > 1))
    end
  end

  def number_of_supporting_bricks(brick, stack_of_bricks) do
    [a, b] = brick

    stack_of_bricks
    |> Enum.filter(fn [_, b] -> b.z == a.z - 1 end)
    |> Enum.count(fn [stack_a, stack_b] = _brick_in_stack ->
      brick_in_stack_x_range = stack_a.x..stack_b.x |> MapSet.new()
      brick_in_stack_y_range = stack_a.y..stack_b.y |> MapSet.new()

      tested_brick_x_range = a.x..b.x |> MapSet.new()
      tested_brick_y_range = a.y..b.y |> MapSet.new()

      !MapSet.disjoint?(brick_in_stack_x_range, tested_brick_x_range) and
        !MapSet.disjoint?(brick_in_stack_y_range, tested_brick_y_range)
    end)
  end

  def supported_bricks(brick, stack_of_bricks) do
    [a, b] = brick

    stack_of_bricks
    |> Enum.filter(fn [a, _b] -> a.z == b.z + 1 end)
    |> Enum.filter(fn [stack_a, stack_b] = _brick_in_stack ->
      brick_in_stack_x_range = stack_a.x..stack_b.x |> MapSet.new()
      brick_in_stack_y_range = stack_a.y..stack_b.y |> MapSet.new()

      tested_brick_x_range = a.x..b.x |> MapSet.new()
      tested_brick_y_range = a.y..b.y |> MapSet.new()

      !MapSet.disjoint?(brick_in_stack_x_range, tested_brick_x_range) and
        !MapSet.disjoint?(brick_in_stack_y_range, tested_brick_y_range)
    end)
  end

  def fall_bricks(bricks) do
    bricks
    |> Enum.with_index()
    |> Enum.reduce([], fn {[a, _b] = brick, index}, stack ->
      IO.inspect(index)

      if a.z == 1 do
        [brick | stack]
      else
        [do_fall_a_single_brick(brick, stack) | stack]
      end
    end)
  end

  def do_fall_a_single_brick([%{z: 1}, _b] = brick, _stack_of_bricks), do: brick

  def do_fall_a_single_brick([a, b] = brick, stack_of_bricks) do
    # IO.inspect(brick, label: "BRICK")
    # IO.inspect(stack_of_bricks, label: "STACK")

    [new_a, new_b] = fallen_brick = [%{a | z: a.z - 1}, %{b | z: b.z - 1}]

    if Enum.find(stack_of_bricks, fn [stack_a, stack_b] = _brick_in_stack ->
         brick_in_stack_x_range = stack_a.x..stack_b.x |> MapSet.new()
         brick_in_stack_y_range = stack_a.y..stack_b.y |> MapSet.new()

         fallen_brick_x_range = new_a.x..new_b.x |> MapSet.new()
         fallen_brick_y_range = new_a.y..new_b.y |> MapSet.new()

         new_a.z == stack_b.z and !MapSet.disjoint?(brick_in_stack_x_range, fallen_brick_x_range) and
           !MapSet.disjoint?(brick_in_stack_y_range, fallen_brick_y_range)
       end) do
      brick
    else
      do_fall_a_single_brick(fallen_brick, stack_of_bricks)
    end
  end

  def load_bricks(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [a, b] = String.split(line, "~", trim: true)

      [xa, ya, za] = String.split(a, ",", trim: true) |> Enum.map(&String.to_integer/1)
      [xb, yb, zb] = String.split(b, ",", trim: true) |> Enum.map(&String.to_integer/1)

      {%{x: xa, y: ya, z: za}, %{x: xb, y: yb, z: zb}}
    end)
    |> Enum.sort_by(fn {a, _} -> a.z end)
  end

  def load(:example) do
    File.read!("lib/day22/example.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(22) |> String.trim()
end
