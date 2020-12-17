defmodule Day15Test do
  use ExUnit.Case
  alias Aoc2020.Day15

  test "day 15 part 1" do
    assert Day15.part1() == 249
  end

  @tag :skip
  test "day 15 part 2" do
    assert Day15.part2() == 41687
  end
end
