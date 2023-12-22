defmodule Day22.Part2 do
  def call(type \\ :example) do
    stack_of_bricks =
      case type do
        :example ->
          data = load(type)

          bricks = load_bricks(data)

          fall_bricks(bricks)

        :input ->
          File.read!("lib/day22/stack_of_bricks.json")
          |> Jason.decode!(keys: :atoms)
      end
      |> Enum.sort_by(fn [a, _] -> a.z end)

    Enum.map(stack_of_bricks, fn brick ->
      calculate_chain_reaction([brick], stack_of_bricks, 0)
    end)
  end

  def calculate_chain_reaction(bricks, stack_of_bricks, counter) do
    case upper_floor_bricks_that_will_collapse(bricks, stack_of_bricks) do
      [[], _] ->
        counter

      [collapsed_bricks, new_stack] ->
        calculate_chain_reaction(
          collapsed_bricks,
          new_stack,
          counter + length(collapsed_bricks)
        )
    end
  end

  def upper_floor_bricks_that_will_collapse(bricks, stack_of_bricks) do
    supported_bricks =
      Enum.flat_map(bricks, &supported_bricks(&1, stack_of_bricks))
      |> Enum.uniq()

    case supported_bricks do
      [] ->
        [[], stack_of_bricks]

      supported_bricks ->
        new_stock = Enum.reject(stack_of_bricks, &Enum.member?(bricks, &1))

        collapsed_bricks =
          supported_bricks
          |> Enum.map(fn brick ->
            {brick, supporting_bricks(brick, new_stock)}
          end)
          |> Enum.filter(fn
            {_brick, []} -> true
            _ -> false
          end)
          |> Enum.map(fn {brick, _supporting_bricks} ->
            brick
          end)

        [collapsed_bricks, new_stock]
    end
  end

  def supporting_bricks(brick, stack_of_bricks) do
    [a, b] = brick

    stack_of_bricks
    |> Enum.filter(fn [_, b] -> b.z == a.z - 1 end)
    |> Enum.filter(fn [stack_a, stack_b] = _brick_in_stack ->
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
    |> Enum.reduce([], fn [a, _b] = brick, stack ->
      if a.z == 1 do
        [brick | stack]
      else
        [do_fall_a_single_brick(brick, stack) | stack]
      end
    end)
  end

  def do_fall_a_single_brick([%{z: 1}, _b] = brick, _stack_of_bricks), do: brick

  def do_fall_a_single_brick([a, b] = brick, stack_of_bricks) do
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

      [%{x: xa, y: ya, z: za}, %{x: xb, y: yb, z: zb}]
    end)
    |> Enum.sort_by(fn [a, _] -> a.z end)
  end

  def load(:example) do
    File.read!("lib/day22/example.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(22) |> String.trim()
end
