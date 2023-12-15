defmodule Day15 do
  def call do
    data = load(:input)

    data
    |> String.split(",", trim: true)
    |> Enum.map(fn hash ->
      calculate(hash)
    end)
    |> Enum.sum()
  end

  def calculate(hash) do
    hash
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
