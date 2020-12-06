defmodule Aoc2020.Day6 do
  def input() do
    File.read!("input/day6.txt")
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(
         fn group ->
           tokens = String.graphemes(group)
           {Enum.count(tokens, &(&1 == "\n")) + 1, Enum.filter(tokens, &(&1 != "\n"))}
         end
       )
  end

  def part1() do
    input()
    |> Enum.map(
         fn {_, answers} ->
           answers
           |> MapSet.new()
           |> Enum.count()
         end
       )
    |> Enum.sum()

  end

  def part2() do
    input()
    |> Enum.map(
         fn {count, answers} ->
           answers
           |> Enum.frequencies()
           |> Enum.filter(
                fn {_, value} ->
                  value == count
                end
              )
           |> Enum.count()
         end
       )
    |> Enum.sum()
  end
end