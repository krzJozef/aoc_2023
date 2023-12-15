defmodule Day14.Part2 do
  use Memoize

  def call do
    data = load(:input)

    1..150
    |> Enum.reduce(data, fn index, acc ->
      result =
        perform_cycle(acc)
        |> Enum.join("\n")

      result
      |> split_into_vertical_lines()
      |> String.split("\n", trim: true)
      |> Enum.map(&calculate_line_score/1)
      |> Enum.sum()
      |> IO.inspect(label: index)

      result
    end)
    # |> Enum.join("\n")
    |> split_into_vertical_lines()
    |> String.split("\n", trim: true)
    |> Enum.map(&calculate_line_score/1)
    |> Enum.sum()
  end

  defmemo perform_cycle(data), expires_in: :timer.hours(1) do
    data
    |> split_into_vertical_lines()
    |> String.split("\n", trim: true)
    |> Enum.map(&move_rocks(&1, :left))
    |> Enum.join("\n")
    |> split_into_vertical_lines()
    |> String.split("\n", trim: true)
    |> Enum.map(&move_rocks(&1, :left))
    |> Enum.join("\n")
    |> split_into_vertical_lines()
    |> String.split("\n", trim: true)
    |> Enum.map(&move_rocks(&1, :right))
    |> Enum.join("\n")
    |> split_into_vertical_lines()
    |> String.split("\n", trim: true)
    |> Enum.map(&move_rocks(&1, :right))
  end

  def move_rocks(line, :left) do
    line
    |> String.split("", trim: true)
    |> Enum.chunk_by(&(&1 == "#"))
    |> Enum.map(fn chunk ->
      if Enum.all?(chunk, &(&1 == "#")) do
        chunk
      else
        Enum.sort(chunk, fn a, b -> rocks_sorter(a, b, :left) end)
      end
    end)
    |> Enum.join("")
  end

  def move_rocks(line, :right) do
    line
    |> String.split("", trim: true)
    |> Enum.chunk_by(&(&1 == "#"))
    |> Enum.map(fn chunk ->
      if Enum.all?(chunk, &(&1 == "#")) do
        chunk
      else
        Enum.sort(chunk, fn a, b -> rocks_sorter(a, b, :right) end)
      end
    end)
    |> Enum.join("")
  end

  def calculate_line_score(line) do
    line
    |> String.split("", trim: true)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {rock, index}, acc ->
      if rock == "O" do
        acc + index + 1
      else
        acc
      end
    end)
  end

  def rocks_sorter("O", ".", :left), do: true
  def rocks_sorter(".", "O", :left), do: false
  def rocks_sorter(".", ".", :left), do: true
  def rocks_sorter("O", "O", :left), do: false

  def rocks_sorter("O", ".", :right), do: false
  def rocks_sorter(".", "O", :right), do: true
  def rocks_sorter(".", ".", :right), do: false
  def rocks_sorter("O", "O", :right), do: true

  def split_into_vertical_lines(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.reduce([], fn line, acc ->
      line = String.trim(line)

      [String.split(line, "", trim: true) | acc]
    end)
    |> Enum.reverse()
    |> Enum.zip()
    |> Enum.map(fn column_tuple ->
      column_tuple
      |> Tuple.to_list()
      |> Enum.join("")
    end)
    |> Enum.join("\n")
  end

  def load(:example) do
    "O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#...."
  end

  def load(:input), do: Api.get_input(14) |> String.trim()
end
