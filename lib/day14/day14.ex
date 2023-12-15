defmodule Day14 do
  def call do
    data = load(:input)

    data
    |> split_into_vertical_lines()
    |> IO.inspect(label: "DUPA")
    |> String.split("\n", trim: true)
    |> Enum.map(&move_rocks/1)
    |> Enum.map(&calculate_line_score/1)
    |> Enum.sum()
  end

  def move_rocks(line) do
    line
    |> String.split("", trim: true)
    |> Enum.chunk_by(&(&1 == "#"))
    |> Enum.map(fn chunk ->
      if Enum.all?(chunk, &(&1 == "#")) do
        chunk
      else
        Enum.sort(chunk, &rocks_sorter/2)
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

  def rocks_sorter("O", "."), do: true
  def rocks_sorter(".", "O"), do: false
  def rocks_sorter(".", "."), do: true
  def rocks_sorter("O", "O"), do: false

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

[
  "OOOO.#O...",
  "OO..#....#",
  "OOO..##O..",
  "O..#OO....",
  "........#.",
  "..#....#.#",
  "O....#OO..",
  "O.........",
  "#....###..",
  "#....#...."
]

[
  "..OOOOOO##",
  ".......OOO",
  "...OO#....",
  "..O#......",
  ".#.......O",
  "#.#..O#.##",
  ".O#....O#.",
  "....O#.O#.",
  "....#.....",
  ".#...#...."
]

[
  ".....#....",
  "....#.O..#",
  "O..O.##...",
  "O.O#......",
  "O.O....O#.",
  "O.#..O.#.#",
  "O....#....",
  "OO....OO..",
  "#O...###..",
  "#O..O#...."
]

[
  ".....#....",
  "....#...O#",
  "...OO##...",
  ".OO#......",
  ".....OOO#.",
  ".O#...O#.#",
  "....O#....",
  "......OOOO",
  "#...O###..",
  "#..OO#...."
]

[
  ".....#....",
  "....#...O#",
  ".....##...",
  "..O#......",
  ".....OOO#.",
  ".O#...O#.#",
  "....O#...O",
  ".......OOO",
  "#...O###.O",
  "#.OOO#...O"
]
