defmodule Aoc2020.Day14 do
  def parse("mask = " <> mask) do
    mask
    |> String.graphemes()
    |> Enum.map(
         fn
           "X" -> :noop
           x -> String.to_integer(x)
         end
       )
  end

  def parse("mem" <> line) do
    [address, value] = Regex.scan(~r/\d+/, line)
                       |> List.flatten
    {String.to_integer(address), String.to_integer(value)}
  end

  def input() do
    input(File.read!("input/day14.txt"))
  end

  def input(text) do
    text
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
  end

  def simulate_value_bitmask([], _mask, memory), do: memory
  def simulate_value_bitmask([next | stream], _mask, memory) when is_list(next),
      do: simulate_value_bitmask(stream, next, memory)
  def simulate_value_bitmask([{address, value} | stream], current_mask, memory) do
    bin = Integer.digits(value, 2)
    value = Enum.concat(List.duplicate(0, length(current_mask) - length(bin)), bin)
    masked_value = Enum.reduce(
                     Enum.zip(current_mask, value),
                     [],
                     fn {x, y}, acc ->
                       case x do
                         0 -> [0 | acc]
                         1 -> [1 | acc]
                         :noop -> [y | acc]
                       end
                     end
                   )
                   |> Enum.reverse()
                   |> Integer.undigits(2)
    memory = Map.put(memory, address, masked_value)
    simulate_value_bitmask(stream, current_mask, memory)
  end

  def permutations([], _), do: [[]]
  def permutations(_, 0), do: [[]]
  def permutations(list, i) do
    for x <- list, y <- permutations(list, i - 1), do: [x | y]
  end

  def modify_address(address, []), do: address
  def modify_address(address, [num | rest]) do
    index = Enum.find_index(address, &(&1 == :floating))
    address = List.replace_at(address, index, num)
    modify_address(address, rest)
  end

  def simulate_address_bitmask([], _mask, memory), do: memory
  def simulate_address_bitmask([next | stream], _mask, memory) when is_list(next),
      do: simulate_address_bitmask(stream, next, memory)
  def simulate_address_bitmask([{address, value} | stream], current_mask, memory) do
    bin = Integer.digits(address, 2)
    address = Enum.concat(List.duplicate(0, length(current_mask) - length(bin)), bin)
    address = Enum.reduce(
                Enum.zip(current_mask, address),
                [],
                fn {x, y}, acc ->
                  case x do
                    0 -> [y | acc]
                    1 -> [1 | acc]
                    :noop -> [:floating | acc]
                  end
                end
              )
              |> Enum.reverse()

    num_floating = Enum.count(address, &(&1 == :floating))

    memory = permutations([0, 1], num_floating)
             |> Enum.reduce(
                  [],
                  fn perm, acc ->
                    [
                      modify_address(address, perm)
                      |> Integer.undigits(2) | acc
                    ]
                  end
                )
             |> Enum.reduce(
                  memory,
                  fn x, acc ->
                    Map.put(acc, x, value)
                  end
                )

    simulate_address_bitmask(stream, current_mask, memory)
  end

  def part1() do
    input()
    |> simulate_value_bitmask(nil, %{})
    |> Map.values()
    |> Enum.sum()
  end

  def part2() do
    input()
    |> simulate_address_bitmask(nil, %{})
    |> Map.values()
    |> Enum.sum()
  end
end
