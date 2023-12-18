defmodule Day18 do
  def call(type \\ :example) do
    data = load(type)

    map = build_map(data)

    calculate(map)
  end

  def calculate(map) do
    map
    |> Enum.with_index()
    |> Enum.reduce(0, fn {row, y}, acc ->
      row_score =
        row
        |> Enum.with_index()
        |> Enum.reduce(%{score: 0, is_enclosed: false, previous_element: nil}, fn {element, x},
                                                                                  %{
                                                                                    score: score,
                                                                                    is_enclosed:
                                                                                      is_enclosed,
                                                                                    previous_element:
                                                                                      previous_element
                                                                                  } ->
          # IO.inspect("#{x}, #{y} - Enclosed: #{is_enclosed}")

          if element == "#" do
            score = score + 1

            is_enclosed =
              if previous_element == "#" do
                is_enclosed
              else
                if is_apex?(row, x, y, map) do
                  # IO.inspect("IS APEX")
                  is_enclosed
                else
                  !is_enclosed
                end
              end

            %{score: score, is_enclosed: is_enclosed, previous_element: element}
          else
            if is_enclosed do
              %{score: score + 1, is_enclosed: is_enclosed, previous_element: element}
            else
              %{score: score, is_enclosed: is_enclosed, previous_element: element}
            end
          end
        end)

      acc + row_score.score
    end)
  end

  def build_map(data) do
    instructions =
      data
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [direction, length, _] = String.split(line, " ", trim: true)
        {direction, String.to_integer(length)}
      end)

    map =
      Enum.reduce(instructions, [{0, 0}], fn {direction, length}, map ->
        {x, y} = List.first(map)

        new_elements =
          case direction do
            "R" ->
              Enum.map(1..length, fn index ->
                {x + index, y}
              end)

            "L" ->
              Enum.map(1..length, fn index ->
                {x - index, y}
              end)

            "U" ->
              Enum.map(1..length, fn index ->
                {x, y - index}
              end)

            "D" ->
              Enum.map(1..length, fn index ->
                {x, y + index}
              end)
          end

        new_elements = new_elements |> Enum.reverse()

        new_elements ++ map
      end)
      |> Enum.reverse()

    draw_map(map)
  end

  def draw_map(map) do
    horizontal_minimum =
      Enum.min_by(map, fn {x, _y} -> x end) |> elem(0) |> IO.inspect(label: "horizontal")

    vertical_minimum =
      Enum.min_by(map, fn {_x, y} -> y end) |> elem(1) |> IO.inspect(label: "vertical")

    map =
      Enum.map(map, fn {x, y} ->
        x = x - horizontal_minimum + 1
        y = y - vertical_minimum + 1

        {x, y}
      end)

    horizontal_size = Enum.max_by(map, fn {x, _y} -> x end) |> elem(0) |> Kernel.+(1)

    vertical_size = Enum.max_by(map, fn {_x, y} -> y end) |> elem(1) |> Kernel.+(1)

    Enum.map(0..(vertical_size - 1), fn y ->
      a =
        Enum.map(0..(horizontal_size - 1), fn x ->
          element =
            if {x, y} in map do
              "#"
            else
              "."
            end

          IO.write(element)

          element
        end)

      IO.puts("")
      a
    end)
  end

  def is_apex?(line, x, y, map) do
    apex_start = x

    apex_length =
      line
      |> Enum.drop(x)
      |> Enum.join("")
      |> String.split(".", trim: true)
      |> List.first()
      |> String.length()

    if apex_length == 1 do
      false
    else
      apex_end = apex_start + apex_length - 1

      (map |> Enum.at(y - 1) |> Enum.at(apex_start) == "#" and
         map |> Enum.at(y - 1) |> Enum.at(apex_end) == "#") or
        (map |> Enum.at(y + 1) |> Enum.at(apex_start) == "#" and
           map |> Enum.at(y + 1) |> Enum.at(apex_end) == "#")
    end
  end

  def load(:example) do
    File.read!("lib/day18/example.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(18) |> String.trim()
end
