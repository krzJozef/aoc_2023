defmodule Day5.Part2 do
  def call do
    data = load_example()
    data = load()

    # seeds = load_seeds(data)

    posibble_results = 1..389_056_265 |> Enum.into([])

    to_soil = load_map(data, "seed-to-soil")
    to_fertilizer = load_map(data, "soil-to-fertilizer")
    to_water = load_map(data, "fertilizer-to-water")
    to_light = load_map(data, "water-to-light")
    to_temperature = load_map(data, "light-to-temperature")
    to_humidity = load_map(data, "temperature-to-humidity")
    to_location = load_map(data, "humidity-to-location")

    posibble_results
    |> Enum.with_index()
    |> Enum.map(fn {result, index} ->
      if rem(index, 100_000) == 0 do
        IO.inspect(index)
      end

      seed =
        result
        |> map_to_destination(to_location)
        |> map_to_destination(to_humidity)
        |> map_to_destination(to_temperature)
        |> map_to_destination(to_light)
        |> map_to_destination(to_water)
        |> map_to_destination(to_fertilizer)
        |> map_to_destination(to_soil)

      if check_seed(seed) do
        IO.inspect(result, label: "RESULT")
        IO.inspect(seed, label: "SEED")
      end
    end)
  end

  defp check_seed(seed) do
    seed in 4_239_267_129..(4_239_267_129 + 20_461_805) or
      seed in 2_775_736_218..(2_775_736_218 + 52_390_530) or
      seed in 3_109_225_152..(3_109_225_152 + 741_325_372) or
      seed in 1_633_502_651..(1_633_502_651 + 46_906_638) or
      seed in 967_445_712..(967_445_712 + 47_092_469) or
      seed in 2_354_891_449..(2_354_891_449 + 237_152_885) or
      seed in 2_169_258_488..(2_169_258_488 + 111_184_803) or
      seed in 2_614_747_853..(2_614_747_853 + 123_738_802) or
      seed in 620_098_496..(620_098_496 + 291_114_156) or
      seed in 2_072_253_071..(2_072_253_071 + 28_111_202)
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
      source >= mapper.destination_start and source < mapper.destination_start + mapper.range
    end)
    |> case do
      nil ->
        source

      %{source_start: source_start, destination_start: destination_start} ->
        offset = destination_start - source_start
        source - offset
    end
  end

  def load_seeds(data) do
    IO.inspect("START LOADING SEEDS")

    "seeds: " <> seeds =
      data
      |> String.split("\n\n", trim: true)
      |> List.first()
      |> String.trim()

    seeds
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.flat_map(fn [start, range] ->
      IO.inspect(start, label: "START")
      IO.inspect(range, label: "RANGE")
      start..(start + range - 1)
    end)
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
