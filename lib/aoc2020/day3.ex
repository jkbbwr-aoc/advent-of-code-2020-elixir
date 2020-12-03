defmodule Aoc2020.Day3 do
  def input() do
    File.read!("input/day3.txt")
    |> String.split("\n")
    |> Enum.map(
         fn line ->
           line
           |> String.graphemes()
           |> Stream.cycle()
         end
       )
  end

  def count_trees(lines, pos \\ 3, right \\ 3, down \\ 1, tree_count \\ 0)
  def count_trees([], _pos, _right, _down, tree_count), do: tree_count
  def count_trees(lines, pos, right, down, tree_count) do
    [line | lines] = Enum.drop(lines, down - 1)

    [character] = line
                  |> Stream.drop(pos)
                  |> Enum.take(1)

    case character do
      "." -> count_trees(lines, pos + right, right, down, tree_count)
      "#" -> count_trees(lines, pos + right, right, down, tree_count + 1)
    end
  end

  def count_slopes(lines, slopes) do
    Enum.map(
      slopes,
      fn {right, down} ->
        lines
        |> Enum.drop(1)
        |> count_trees(right, right, down)
      end
    )
  end

  def part1() do
    input()
    |> Enum.drop(1)
    |> count_trees
  end

  def part2() do
    input()
    |> count_slopes([{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}])
    |> Enum.reduce(&(&1 * &2))
  end
end
