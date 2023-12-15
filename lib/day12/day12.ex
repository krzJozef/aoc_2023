defmodule Day12 do
  def call do
    data = load(:input)

    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [text, block_lengths_string] = String.split(line, " ", trim: true)

      block_lengths =
        block_lengths_string
        |> String.trim()
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)

      text = String.trim(text)

      text
      |> generate_all_possibilities()
      |> Enum.count(fn possibility -> is_correct(possibility, block_lengths) end)
    end)
    |> Enum.sum()
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
