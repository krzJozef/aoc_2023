defmodule Day12.Part2 do
  use Memoize

  def call do
    data = load(:input)

    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {elements, group_sizes} = unfold(line)
      do_call(elements, group_sizes)
    end)
    |> Enum.sum()
  end

  defmemo do_call(elements, []) do
    if Enum.any?(elements, &(&1 == "#")) do
      0
    else
      1
    end
  end

  defmemo do_call(elements, [current_group_size | remaining_groups]), expires_in: :timer.hours(1) do
    tail_size = Enum.sum(remaining_groups) + length(remaining_groups)

    Enum.map(0..(length(elements) - tail_size - current_group_size), fn index ->
      if can_fit(elements, index, current_group_size) do
        remaining_elements =
          elements
          |> Enum.slice(index + current_group_size, length(elements))
          |> case do
            [] ->
              []

            # if remaining elements start with unknown, replace it with mandatory operational element
            ["?" | rest] ->
              ["."] ++ rest

            ["." | _] = rest ->
              rest
          end

        do_call(remaining_elements, remaining_groups)
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def can_fit(elements, index, current_group_size) do
    group_fits? =
      elements
      |> Enum.slice(index, current_group_size)
      |> Enum.all?(&(&1 in ["#", "?"]))

    next_element_fits? = Enum.at(elements, index + current_group_size) in [nil, ".", "?"]

    previous_fit? =
      elements
      |> Enum.take(index)
      |> Enum.all?(&(&1 in [".", "?"]))

    group_fits? and next_element_fits? and previous_fit?
  end

  def unfold(line) do
    [elements_str, group_sizes_str] = String.split(line, " ", trim: true)

    elements = String.split(elements_str, "", trim: true)

    elements =
      Enum.reduce(1..4, elements, fn _, unfolded_elements ->
        unfolded_elements ++ ["?"] ++ elements
      end)

    group_sizes =
      Enum.reduce(1..4, group_sizes_str, fn _, unfolded_group_sizes ->
        unfolded_group_sizes <> "," <> group_sizes_str
      end)
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    {elements, group_sizes}
  end

  def is_correct(line, block_lengths) do
    blocks = String.split(line, ".", trim: true)

    if length(blocks) == length(block_lengths) do
      Enum.zip(blocks, block_lengths)
      |> Enum.all?(fn {block, length} -> String.length(block) == length end)
    else
      false
    end
  end

  def generate_all_possibilities(line) do
    if String.contains?(line, "?") do
      generate_all_possibilities(String.replace(line, "?", "#", global: false)) ++
        generate_all_possibilities(String.replace(line, "?", ".", global: false))
    else
      [line]
    end
  end

  def load(:example) do
    "???.### 1,1,3
  .??..??...?##. 1,1,3
  ?#?#?#?#?#?#?#? 1,3,1,6
  ????.#...#... 4,1,1
  ????.######..#####. 1,6,5
  ?###???????? 3,2,1"
  end

  def load(:input), do: Api.get_input(12) |> String.trim()
end

# ".??..??...?##." 1,1,3
# "?.??..??...?##." 1,1,3

# "#.#........###."
# "#..#.......###."
# "#......#...###."
# "#.....#....###."
# "..#....#...###."
# "..#...#....###."
# "...#...#...###."
# "...#..#....###."
