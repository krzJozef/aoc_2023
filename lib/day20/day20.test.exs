defmodule Day20Test do
  use ExUnit.Case

  alias Day20, as: Subject

  # module = %{
  #   name: "a",
  #   type: "%",
  #   state: "off",
  #   destinations: [
  #     "b"
  #   ]
  # }

  # %{
  #   name: "inv",
  #   type: "&",
  #   state: %{
  #     "a" => :low
  #   },
  #   destinations: [
  #     "a"
  #   ]
  # }

  describe "send_pulse" do
    test "low pulse to flip flop modules" do
      assert {:high,
              %{
                name: "a",
                type: "%",
                state: "on",
                destinations: ["b"]
              },
              ["b"]} ==
               Subject.send_pulse(:low, "a", %{
                 name: "a",
                 type: "%",
                 state: "off",
                 destinations: ["b"]
               })

      assert {:high,
              %{
                name: "b",
                type: "%",
                state: "on",
                destinations: ["c"]
              },
              ["c"]} ==
               Subject.send_pulse(:low, "b", %{
                 name: "b",
                 type: "%",
                 state: "off",
                 destinations: ["c"]
               })

      assert {:low,
              %{
                name: "b",
                type: "%",
                state: "off",
                destinations: ["inv"]
              },
              ["inv"]} ==
               Subject.send_pulse(:low, "c", %{
                 name: "b",
                 type: "%",
                 state: "on",
                 destinations: ["inv"]
               })
    end

    test "low pulse to conjuction modules" do
      assert {:low,
              %{
                name: "inv",
                type: "&",
                state: %{"c" => :high},
                destinations: ["b"]
              },
              ["b"]} ==
               Subject.send_pulse(:high, "c", %{
                 name: "inv",
                 type: "&",
                 state: %{"c" => :low},
                 destinations: ["b"]
               })

      assert {:high,
              %{
                name: "inv",
                type: "&",
                state: %{"c" => :high, "d" => :low},
                destinations: ["b"]
              },
              ["b"]} ==
               Subject.send_pulse(:high, "c", %{
                 name: "inv",
                 type: "&",
                 state: %{"c" => :low, "d" => :low},
                 destinations: ["b"]
               })
    end
  end

  test "cycle" do
    data = %{
      "broadcaster" => %{
        name: "broadcaster",
        type: "broadcaster",
        state: nil,
        destinations: ["a", "b", "c"]
      },
      "a" => %{name: "a", type: "%", state: "off", destinations: ["b"]},
      "b" => %{name: "b", type: "%", state: "off", destinations: ["c"]},
      "c" => %{name: "c", type: "%", state: "off", destinations: ["inv"]},
      "inv" => %{name: "inv", type: "&", state: %{"c" => :low}, destinations: ["a"]}
    }

    pulses = Subject.cycle(data)

    assert 4 == Enum.count(pulses, &(&1 == :high))
    assert 8 == Enum.count(pulses, &(&1 == :low))
  end
end
