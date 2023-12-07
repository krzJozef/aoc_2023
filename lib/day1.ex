defmodule Day1 do
  def call do
    load()
    |> String.split("\n")
    |> Enum.map(fn line ->
      numbers =
        line
        |> String.split("")
        |> Enum.reject(&(Integer.parse(&1) == :error))

      first = List.first(numbers)
      last = List.last(numbers)
      String.to_integer("#{first}#{last}")
    end)
    |> Enum.sum()
  end

  def call2 do
    load()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line =
        line
        |> String.replace("one", "one1one")
        |> String.replace("two", "two2two")
        |> String.replace("three", "three3three")
        |> String.replace("four", "four4four")
        |> String.replace("five", "five5five")
        |> String.replace("six", "six6six")
        |> String.replace("seven", "seven7seven")
        |> String.replace("eight", "eight8eight")
        |> String.replace("nine", "nine9nine")

      numbers =
        line
        |> String.split("")
        |> Enum.reject(&(Integer.parse(&1) == :error))

      first = List.first(numbers)
      last = List.last(numbers)
      String.to_integer("#{first}#{last}")
    end)
    |> Enum.sum()
  end

  defp load do
    Api.get_input(1) |> String.trim()
  end
end
