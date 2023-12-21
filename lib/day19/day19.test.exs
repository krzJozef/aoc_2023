defmodule Day19Test do
  use ExUnit.Case

  alias Day19, as: Subject

  test "apply_rule" do
    assert :nope ==
             Subject.apply_rule(%{x: 787, m: 2655, a: 1222, s: 2876}, %{
               element: "s",
               sign: "<",
               value: 1351,
               goto: "px"
             })

    assert "qs" ==
             Subject.apply_rule(%{x: 787, m: 2655, a: 1222, s: 2876}, %{
               element: "s",
               sign: ">",
               value: 2770,
               goto: "qs"
             })
  end
end
