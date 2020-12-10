defmodule Aoc2020.Day9 do
  def input() do
    File.read!("input/day9.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def process(list) do
    [target | rest] = Enum.reverse(list)
    perms = for x <- rest, y <- rest, x != y, do: [x, y]
    !(Enum.find(perms, fn [x, y] -> x + y == target end))
  end

  def part1() do
    input()
    |> Enum.chunk_every(26, 1, :discard)
    |> Enum.filter(&process/1)
    |> List.first
    |> List.last
  end

  def search(list, goal, size) do
    list
    |> Enum.chunk_every(size, 1, :discard)
    |> Enum.find(fn list -> Enum.sum(list) == goal end)
  end

  def while_searching(list, goal, size) do
    case search(list, goal, size) do
      nil -> while_searching(list, goal, size + 1)
      x -> x
    end
  end

  def part2() do
    result = input()
    |> while_searching(part1(), 2)
    Enum.min(result) + Enum.max(result)
  end
end
