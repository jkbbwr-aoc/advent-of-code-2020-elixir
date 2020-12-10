defmodule Aoc2020.Day7 do
  def parse(line) do
    bag_counts = fn
      "no other bags." -> []
      x -> {count, bag} = Integer.parse(x)
           bag = bag
                 |> String.split(" ", trim: true)
                 |> Enum.take(2)
                 |> Enum.join(" ")
           {count, bag}
    end
    [left, right] = String.split(line, " bags contain ")
    bags = right
           |> String.split(", ")
           |> Enum.map(bag_counts)
    %{left => bags}
  end

  def input() do
    File.read!("input/day7.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
    |> Enum.reduce(%{}, &Map.merge(&1, &2))
  end

  def search_bag(key, map) do
    children = Map.get(map, key)
               |> Enum.filter(&(&1 != []))
               |> Enum.map(fn {_, x} -> x end)
    "shiny gold" in children or Enum.any?(children, &search_bag(&1, map))
  end

  def count_bag({count, bag}, map) do
    children = Map.get(map, bag)
    Enum.reduce(
      children,
      0,
      fn
        [], acc -> acc
        x, acc -> count_bag(x, map) + acc
      end
    ) * count + count
  end

  def part1() do
    bags = input()
    Enum.reduce(
      Map.keys(bags),
      [],
      fn x, acc ->
        if search_bag(x, bags), do: [x | acc], else: acc
      end
    )
    |> Enum.count()
  end

  def part2() do
    bags = input()
    nodes = Map.get(bags, "shiny gold")
    Enum.reduce(nodes, 0, fn x, acc -> count_bag(x, bags) + acc end)
  end
end
