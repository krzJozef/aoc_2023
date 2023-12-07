defmodule Day5 do
  def call do
    data = load()

    seeds = load_seeds(data)

    to_soil = load_map(data, "seed-to-soil")
    to_fertilizer = load_map(data, "soil-to-fertilizer")
    to_water = load_map(data, "fertilizer-to-water")
    to_light = load_map(data, "water-to-light")
    to_temperature = load_map(data, "light-to-temperature")
    to_humidity = load_map(data, "temperature-to-humidity")
    to_location = load_map(data, "humidity-to-location")

    seeds
    |> Enum.map(fn seed ->
      result =
        seed
        |> map_to_destination(to_soil)
        |> map_to_destination(to_fertilizer)
        |> map_to_destination(to_water)
        |> map_to_destination(to_light)
        |> map_to_destination(to_temperature)
        |> map_to_destination(to_humidity)
        |> map_to_destination(to_location)

      IO.inspect("-------------")
      IO.inspect(seed)
      IO.inspect(result)
      IO.inspect("-------------")

      result
    end)
    |> Enum.min()
  end

  def load_map(data, type) do
    [_ | mappers] =
      data
      |> String.split("\n\n", trim: true)
      |> Enum.find(&String.contains?(&1, type))
      |> String.split("\n", trim: true)

    mappers
    |> Enum.map(fn line ->
      [destination_start, source_start, range] =
        line
        |> String.trim()
        |> String.split(" ", trim: true)

      %{
        source_start: String.to_integer(source_start),
        destination_start: String.to_integer(destination_start),
        range: String.to_integer(range)
      }
    end)
  end

  def map_to_destination(source, map) do
    Enum.find(map, fn mapper ->
      source >= mapper.source_start and source <= mapper.source_start + mapper.range
    end)
    |> case do
      nil ->
        source

      %{source_start: source_start, destination_start: destination_start} ->
        offset = source - source_start
        destination_start + offset
    end
  end

  def load_seeds(data) do
    "seeds: " <> seeds =
      data
      |> String.split("\n\n", trim: true)
      |> List.first()
      |> String.trim()

    seeds
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def load_example do
    "seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4"
    |> String.trim()
  end

  def load do
    Api.get_input(5) |> String.trim()
  end
end
