defmodule Day5Test do
  use ExUnit.Case

  alias Day5, as: Subject

  test "load_map" do
    assert [
             %{
               source_start: 98,
               destination_start: 50,
               range: 2
             },
             %{
               source_start: 50,
               destination_start: 52,
               range: 48
             }
           ] == Subject.load_map(data(), "seed-to-soil")

    assert [
             %{
               source_start: 77,
               destination_start: 45,
               range: 23
             },
             %{
               source_start: 45,
               destination_start: 81,
               range: 19
             },
             %{
               source_start: 64,
               destination_start: 68,
               range: 13
             }
           ] == Subject.load_map(data(), "light-to-temperature")
  end

  test "map_to_destination" do
    soil_map = [
      %{
        source_start: 98,
        destination_start: 50,
        range: 2
      },
      %{
        source_start: 50,
        destination_start: 52,
        range: 48
      }
    ]

    assert 81 == Subject.map_to_destination(79, soil_map)
    assert 14 == Subject.map_to_destination(14, soil_map)
    assert 57 == Subject.map_to_destination(55, soil_map)
    assert 13 == Subject.map_to_destination(13, soil_map)
    assert 51 == Subject.map_to_destination(99, soil_map)

    temperature_map = [
      %{
        source_start: 77,
        destination_start: 45,
        range: 23
      },
      %{
        source_start: 45,
        destination_start: 81,
        range: 19
      },
      %{
        source_start: 64,
        destination_start: 68,
        range: 13
      }
    ]

    assert 78 == Subject.map_to_destination(74, temperature_map)
    assert 42 == Subject.map_to_destination(42, temperature_map)
    assert 82 == Subject.map_to_destination(46, temperature_map)
    assert 34 == Subject.map_to_destination(34, temperature_map)
  end

  defp data do
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
  end
end

[
  4_239_267_129,
  20_461_805,
  2_775_736_218,
  52_390_530,
  3_109_225_152,
  741_325_372,
  1_633_502_651,
  46_906_638,
  967_445_712,
  47_092_469,
  2_354_891_449,
  237_152_885,
  2_169_258_488,
  111_184_803,
  2_614_747_853,
  123_738_802,
  620_098_496,
  291_114_156,
  2_072_253_071,
  28_111_202
]

"26 - 1"
"27 - 2"
"28 - 3"
"29 - 4"
"30 - 5"
"31 - 6"
"32 - 7"
"33 - 8"
"34 - 9"
"35 - 10"
"36 - 11"
"37 - 12"
"38 - 13"
"39 - 14"
"40 - 15"
"41 - 16"
"42 - 17"
"43 - 18"

"50 - 20"
"51 - 21"
"52 - 22"
# --------------------
"0 - 22"
"1 - 23"
"2 - 24"
"3 - 25"
"4 - 26"
"5 - 27"
"6 - 28"
"7 - 29"
"8 - 30"
"9 - 31"
"10 - 32"
"11 - 33"
"12 - 34"
"13 - 35"

"14 - 43"

"15 - 36"
"16 - 37"
"17 - 38"
"18 - 39"
"19 - 40"
"20 - 41"
"21 - 42"
"22 - 43"

"23 - 91"
"24 - 92"
"25 - 93"

"26 - 1"
"27 - 2"
"28 - 3"
"29 - 4"
"30 - 5"
"31 - 6"
"32 - 7"
"33 - 8"
"34 - 9"
"35 - 10"
"36 - 11"
"37 - 12"
"38 - 13"
"39 - 14"
"40 - 15"
"41 - 16"
"42 - 17"
"43 - 18"

"44 - 61"
"45 - 62"
"46 - 63"
"47 - 64"
"48 - 65"
"49 - 66"

"50 - 20"
"51 - 21"
"52 - 22"

"53 - 45"

"54 - 85"
"55 - 86"
"56 - 87"
"57 - 88"
"58 - 89"
"59 - 90"

"60 - 95"
"61 - 96"
"62 - 97"

"63 - 57"
"64 - 58"
"65 - 59"
"66 - 60"

"67 - 98"
"68 - 99"
"69 - 100"

"70 - 0"
"71 - 1"

"72 - 75"
"73 - 76"
"74 - 77"
"75 - 78"
"76 - 79"
"77 - 80"
"78 - 81"
"79 - 82"
"80 - 83"
"81 - 84"

"82 - 46"
"83 - 47"
"84 - 48"
"85 - 49"
"86 - 50"
"87 - 51"
"88 - 52"
"89 - 53"
"90 - 54"
"91 - 55"

"92 - 60"
"93 - 61"
"94 - 69"
"95 - 70"
"96 - 71"
"97 - 72"

"98 - 67"
"99 - 68"

"100 - 20"
