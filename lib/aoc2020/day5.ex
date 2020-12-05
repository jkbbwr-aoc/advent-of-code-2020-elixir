defmodule Aoc2020.Day5 do
  def letter("F"), do: :lower
  def letter("B"), do: :upper
  def letter("L"), do: :lower
  def letter("R"), do: :upper

  def convert(entry) do
    String.graphemes(entry)
    |> Enum.map(&letter/1)
  end

  def input() do
    File.read!("input/day5.txt")
    |> String.split("\n")
    |> Enum.map(&convert/1)
  end

  def traverse(range, direction) do
    len = round(length(range) / 2)
    [lower | [upper]] = Enum.chunk_every(range, len)
    case direction do
      :lower -> lower
      :upper -> upper
    end
  end

  def calculate(entry) do
    row_range = Enum.to_list(0..127)
    [row] = Enum.reduce(
      Enum.take(entry, 7),
      row_range,
      fn x, acc ->
        traverse(acc, x)
      end
    )
    column_range = Enum.to_list(0..7)
    [column] = Enum.reduce(
      Enum.drop(entry, 7),
      column_range,
      fn x, acc ->
        traverse(acc, x)
      end
    )

    (row * 8) + column
  end

  def part1() do
    input()
    |> Enum.map(&calculate/1)
    |> Enum.max()
  end

  def part2() do
    [x, _] = input()
             |> Enum.map(&calculate/1)
             |> Enum.sort()
             |> Enum.chunk_every(2, 1, :discard)
             |> Enum.find(fn [x, y] -> x - y != -1 end)
    x + 1
  end
end
