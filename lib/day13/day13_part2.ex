defmodule Day13.Part2 do
  def call do
    data = load(:input)

    boards = String.split(data, "\n\n", trim: true)

    sum_of_rows = sum_of_rows(boards)

    sum_of_columns = sum_of_columns(boards)

    sum_of_rows * 100 + sum_of_columns
  end

  def sum_of_rows(boards) do
    boards
    |> Enum.map(fn board ->
      case mirrored_rows(board) do
        {:ok, index} -> index
        _ -> 0
      end
    end)
    |> Enum.sum()
  end

  def sum_of_columns(boards) do
    boards
    |> Enum.map(fn board ->
      board = split_into_vertical_lines(board)

      case mirrored_rows(board) do
        {:ok, index} -> index
        _ -> 0
      end
    end)
    |> Enum.sum()
  end

  def mirrored_rows(board) do
    lines = String.split(board, "\n", trim: true) |> Enum.map(&String.trim/1)

    1..length(lines)
    |> Enum.reduce_while(0, fn index, _ ->
      {left, right} = Enum.split(lines, index)

      if length(left) <= length(right) do
        right = Enum.take(right, length(left))

        if number_of_differences(left, right) == 1 do
          {:halt, index}
        else
          {:cont, nil}
        end
      else
        left = left |> Enum.reverse() |> Enum.take(length(right)) |> Enum.reverse()

        if number_of_differences(left, right) == 1 do
          {:halt, index}
        else
          {:cont, nil}
        end
      end
    end)
    |> case do
      index when is_integer(index) -> {:ok, index}
      _ -> :not_found
    end
  end

  def number_of_differences(left, right) do
    left =
      left
      |> Enum.join("")
      |> String.split("", trim: true)
      |> IO.inspect(label: "LEFTT")

    right =
      right
      |> Enum.reverse()
      |> Enum.join("")
      |> String.split("", trim: true)
      |> IO.inspect(label: "RIGHT")

    Enum.zip(left, right)
    |> Enum.count(fn {l, r} -> l != r end)
  end

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

  def load(:input), do: Api.get_input(13) |> String.trim()
end
