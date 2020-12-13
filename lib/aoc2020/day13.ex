defmodule Aoc2020.Day13 do
  def parse("x"), do: :invalid
  def parse(x), do: String.to_integer(x)

  def input() do
    input(File.read!("input/day13.txt"))
  end

  def input(text) do
    [depart_time, raw_schedule] = text
                                  |> String.split("\n", trim: true)
    schedule = raw_schedule
               |> String.split(",", trim: true)
               |> Enum.map(&parse/1)

    {String.to_integer(depart_time), schedule}
  end

  def find_nearest_departure(goal, schedule) when rem(goal, schedule) == 0, do: goal
  def find_nearest_departure(goal, schedule), do: find_nearest_departure(goal + 1, schedule)

  def part1() do
    {goal, schedule} = input()
    {id, closest} = schedule
                    |> Enum.filter(&(&1 != :invalid))
                    |> Enum.map(
                         fn x ->
                           {x, find_nearest_departure(goal, x)}
                         end
                       )
                    |> Enum.min_by(fn {_, y} -> y end)
    id * (closest - goal)
  end

  def do_while(target, n, index, id) when rem(target + index, id) != 0, do: do_while(target + n, n, index, id)
  def do_while(target, _n, _index, _id), do: target

  def part2() do
    {_, schedule} = input()
    fields = schedule
             |> Enum.with_index
             |> Enum.filter(fn {x, _} -> x != :invalid end)

    {target, _} = Enum.reduce(
      fields,
      {0, 1},
      fn {id, index}, {target, n} ->
        {do_while(target, n, index, id), n * id}
      end
    )

    target
  end
end
