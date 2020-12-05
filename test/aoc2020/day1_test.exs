defmodule Day1Test do
  use ExUnit.Case
  alias Aoc2020.Day1

  test "day 1 part 1" do
    assert Day1.part1() == 545379
  end

  test "day 1 part 2" do
    assert Day1.part2() == 257778836
  end
end
