defmodule Aoc2020.Day15 do
  def input() do
    input(File.read!("input/day15.txt"))
  end

  def input(text) do
    nums = text
           |> String.split(",", trim: true)
           |> Enum.map(&String.to_integer/1)

    mem = nums
          |> Enum.with_index(1)
          |> Enum.reduce(
               %{},
               fn {x, index}, acc ->
                 Map.put(acc, x, [index])
               end
             )

    {mem, List.last(nums), length(nums)}
  end

  def step({memory, last_number_spoken, turn}) do
    turn = turn + 1 # idk why this fixes everything...
    case Map.get(memory, last_number_spoken, [turn - 1]) do
      [_x] ->
        memory = Map.update(memory, 0, [turn], &([turn | &1]))
        {memory, 0, turn}
      [x, y | _rest] ->
        memory = Map.update(memory, x - y, [turn], &([turn | &1]))
        {memory, x - y, turn}
    end
  end

  def run({x, y, turn}, goal) when turn == goal, do: {x, y, turn}
  def run(data, goal) do
    run(step(data), goal)
  end

  def part1() do
    {_mem, num, 2020} = input()
                        |> run(2020)
    num
  end

  def part2() do
    {_mem, num, 30000000} = input()
                            |> run(30000000)
    num
  end
end
