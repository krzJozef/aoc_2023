defmodule Day13 do
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

    lines
    |> Enum.with_index()
    |> Enum.reduce_while("", fn {line, index}, previous_line ->
      if line == previous_line do
        {left, right} = Enum.split(lines, index)

        if are_equal?(Enum.reverse(left), right) do
          {:halt, index}
        else
          {:cont, line}
        end
      else
        {:cont, line}
      end
    end)
    |> case do
      index when is_integer(index) -> {:ok, index}
      _ -> :not_found
    end
  end

  def are_equal?([], _), do: true
  def are_equal?(_, []), do: true

  def are_equal?([head | left_tail], [head | right_tail]) do
    are_equal?(left_tail, right_tail)
  end

  def are_equal?(_, _), do: false

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
