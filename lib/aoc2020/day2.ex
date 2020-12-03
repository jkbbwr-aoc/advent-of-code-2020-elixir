defmodule Aoc2020.Day2 do
  @regex ~r/(?'lower'^\d+)\-(?'upper'\d+) (?'letter'\w): (?'rest'.*)/

  def input() do
    File.read!("input/day2.txt")
    |> String.split("\n")
    |> Enum.map(
         fn line ->
           groups = Regex.named_captures(@regex, line)
           {
             String.to_integer(groups["lower"]),
             String.to_integer(groups["upper"]),
             groups["letter"],
             String.graphemes(groups["rest"]),
           }
         end
       )
  end

  def validate_simple({lower, upper, letter, password}) do
    Enum.count(password, &(&1 == letter)) in lower..upper
  end

  def validate_complex({index1, index2, letter, password}) do
    pos1 = password |> Enum.at(index1-1)
    pos2 = password |> Enum.at(index2-1)
    (pos1 == letter or pos2 == letter) and pos1 != pos2
  end

  def part1() do
    input()
    |> Enum.filter(&validate_simple/1)
    |> Enum.count()
  end

  def part2() do
    input()
    |> Enum.filter(&validate_complex/1)
    |> Enum.count()
  end
end
