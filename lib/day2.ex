defmodule Day2 do
  def call do
    # load_example()
    load()
    |> String.split("\n", trim: true)
    |> Enum.map(&handle_single_game/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.sum()
  end

  defp handle_single_game(game_string) do
    game_string = String.trim(game_string)
    ["Game " <> game_number, rounds_string] = String.split(game_string, ": ")

    x =
      rounds_string
      |> String.split(";")
      |> Enum.flat_map(&handle_single_round/1)

    if Enum.all?(x, &(&1 == :ok)), do: String.to_integer(game_number), else: nil
  end

  defp handle_single_round(round_string) do
    round_string
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn string ->
      string = String.trim(string)
      [number, color] = String.split(string, " ")

      number = String.to_integer(number)

      cond do
        color == "red" and number > 12 -> :exceeded
        color == "green" and number > 13 -> :exceeded
        color == "blue" and number > 14 -> :exceeded
        true -> :ok
      end
    end)
  end

  def call2 do
    load()
    |> String.split("\n")
    |> Enum.map(&handle_single_game2/1)
    |> Enum.sum()
  end

  defp handle_single_game2(game_string) do
    game_string = String.trim(game_string)
    ["Game " <> _game_number, rounds_string] = String.split(game_string, ": ")

    x =
      rounds_string
      |> String.split(";")
      |> Enum.flat_map(&handle_single_round2/1)
      |> Enum.group_by(fn {color, _} -> color end)

    blue =
      x["blue"]
      |> Enum.max_by(fn {_, number} -> number end)
      |> elem(1)

    green =
      x["green"]
      |> Enum.max_by(fn {_, number} -> number end)
      |> elem(1)

    red =
      x["red"]
      |> Enum.max_by(fn {_, number} -> number end)
      |> elem(1)

    blue * green * red
  end

  defp handle_single_round2(round_string) do
    round_string
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn string ->
      string = String.trim(string)
      [number, color] = String.split(string, " ")

      number = String.to_integer(number)

      {color, number}
    end)
    |> Enum.into(%{})
  end

  defp load do
    Api.get_input(2) |> String.trim()
  end

  def load_example do
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
    |> String.trim()
  end
end

# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
