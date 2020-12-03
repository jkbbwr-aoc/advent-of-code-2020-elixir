defmodule Aoc2020.Day1 do
  def input() do
    File.read!("input/day1.txt")
    |> String.split()
    |> Enum.map(&(String.to_integer(&1)))
  end

  def find_mistake([first | rest]) do
    target = 2020 - first
    case Enum.find(rest, fn x -> x == target end) do
      nil -> find_mistake(rest)
      x -> first * x
    end
  end

  def find_bigger_mistake(input) do
    try do
      for a <- input, b <- input, c <- input,
          a + b + c == 2020,
          do: throw({:break, {a, b, c}})
    catch
      {:break, {a, b, c}} -> a * b * c
    end
  end

  def part1() do
    input()
    |> Enum.sort()
    |> find_mistake
  end

  def part2() do
    input()
    |> Enum.sort()
    |> find_bigger_mistake
  end
end
