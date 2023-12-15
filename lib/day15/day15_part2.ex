defmodule Day15.Part2 do
  def call do
    data = load(:input)

    boxes = 0..255 |> Enum.map(fn _ -> [] end)

    data
    |> String.split(",", trim: true)
    |> Enum.reduce(boxes, fn hash, boxes ->
      box_number = calculate(hash)

      box = Enum.at(boxes, box_number)

      updated_box = update_box(box, hash)

      List.replace_at(boxes, box_number, updated_box)
    end)
    |> Enum.with_index()
    |> Enum.map(fn {box, box_number} ->
      box
      |> Enum.with_index()
      |> Enum.reduce(0, fn {{_label, power}, place_in_the_box}, acc ->
        (1 + box_number) * (place_in_the_box + 1) * power + acc
      end)
    end)
    |> Enum.sum()
  end

  def update_box(box, hash) do
    if String.contains?(hash, "-") do
      label =
        hash
        |> String.split("-", trim: true)
        |> List.first()
        |> String.to_atom()

      case List.keytake(box, label, 0) do
        {_, new_box} -> new_box
        nil -> box
      end
    else
      [label, power] = String.split(hash, "=", trim: true)
      label = String.to_atom(label)
      power = String.to_integer(power)

      if List.keymember?(box, label, 0) do
        List.keyreplace(box, label, 0, {label, power})
      else
        [{label, power} | box |> Enum.reverse()] |> Enum.reverse()
      end
    end
  end

  def calculate(hash) do
    label =
      if String.contains?(hash, "-") do
        hash |> String.split("-", trim: true) |> List.first()
      else
        hash |> String.split("=", trim: true) |> List.first()
      end

    label
    |> String.split("", trim: true)
    |> Enum.reduce(0, fn char, acc ->
      ascii = :binary.first(char)
      acc = (acc + ascii) * 17
      rem(acc, 256)
    end)
  end

  def load(:example) do
    "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"
  end

  def load(:input), do: Api.get_input(15) |> String.trim()
end
