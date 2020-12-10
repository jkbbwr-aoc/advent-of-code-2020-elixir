defmodule Aoc2020.Day10 do
  _ = """
  I hate combinatorics. It fucking sucks. It always sucks.
  """

  def hack_the_input(input) do
    [0, Enum.max(input) + 3 | input]
  end

  def input() do
    File.read!("input/day10.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)

  end

  def process(input) do
    values = input
             |> Enum.chunk_every(2, 1, :discard)
             |> Enum.map(fn [x, y] -> y - x end)
    Enum.count(values, &(&1 == 1)) * Enum.count(values, &(&1 == 3))
  end

  def chunk_while_inc(input) do
    [head | rest] = input
    Enum.chunk_while(
      rest,
      [head],
      fn
        x, [head | _] = acc when head + 1 == x -> {:cont, [x | acc]}
        x, acc -> {:cont, Enum.reverse(acc), [x]}
      end,
      fn
        [] -> {:cont, []}
        acc -> {:cont, Enum.reverse(acc), []}
      end
    )
  end

  def reduce_to_mappings(input) do
    mappings = %{2 => 1, 3 => 2, 4 => 4, 5 => 7}
    input
    |> chunk_while_inc
    |> Enum.filter(&(length(&1) >= 3))
    |> Enum.map(&(Map.get(mappings, length(&1), 1)))
    |> Enum.reduce(1, &(&1 * &2))
  end

  def part1() do
    input()
    |> hack_the_input()
    |> Enum.sort()
    |> process()
  end

  def part2() do
    input()
    |> Enum.sort()
    |> (fn x -> [0 | x] end).()
    |> reduce_to_mappings()
  end
end
