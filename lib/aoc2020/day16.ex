defmodule Aoc2020.Day16 do
  def input() do
    input(File.read!("input/day16.txt"))
  end

  @range_regex ~r/\d+-\d+/
  def input(text) do
    lines = text
            |> String.split("\n")

    field_ranges = Enum.take_while(lines, &(&1 != ""))
                   |> Enum.map(
                        fn line ->
                          [field | ranges] = String.split(line, ":")
                          {
                            field,
                            Enum.map(
                              Regex.scan(@range_regex, List.first(ranges)),
                              fn [range] ->
                                [left, right | _] = String.split(range, "-")
                                Range.new(String.to_integer(left), String.to_integer(right))
                              end
                            )
                          }
                        end
                      )

    [my_ticket | rest] = Enum.drop_while(lines, &(&1 != ""))
                         |> Enum.drop(2)

    my_ticket = my_ticket
                |> String.split(",", trim: true)
                |> Enum.map(&String.to_integer/1)

    other_tickets = Enum.drop(rest, 2)
                    |> Enum.map(
                         fn line ->
                           line
                           |> String.split(",", trim: true)
                           |> Enum.map(&String.to_integer/1)
                         end
                       )


    [
      rules: field_ranges,
      my_ticket: my_ticket,
      other_tickets: other_tickets
    ]
  end

  def num_in_any_ranges(num, ranges) do
    Enum.any?(ranges, fn x -> num in x end)
  end

  def all_possible_labels_for_field(field, rules) do
    Enum.filter(rules, fn {_, ranges} -> num_in_any_ranges(field, ranges) end)
    |> Enum.map(fn {r, _} -> r end)
  end

  def crush_while_unfinished(possible, fields \\ %{}) do
    if Enum.any?(possible, fn x -> Enum.count(x) != 0 end) do
      index = Enum.find_index(possible, &(Enum.count(&1) == 1))
      value = Enum.at(possible, index)
      possible = Enum.map(possible, fn x -> MapSet.difference(x, value) end)
      crush_while_unfinished(
        possible,
        Map.put(
          fields,
          index,
          value
          |> Enum.at(0)
        )
      )
    else
      fields
    end
  end

  def part1() do
    input = input()
    ranges = Enum.map(input[:rules], fn {_, y} -> y end)
             |> List.flatten()
    Enum.concat(input[:my_ticket], List.flatten(input[:other_tickets]))
    |> List.flatten
    |> Enum.filter(fn x -> Enum.all?(ranges, fn range -> x not in range end) end)
    |> Enum.sum()
  end

  def part2() do
    input = input()
    my_ticket = input[:my_ticket]
    rules = input[:rules]
    ranges = Enum.map(rules, fn {_, y} -> y end)
             |> List.flatten()

    input[:other_tickets]
    |> Enum.filter(fn ticket -> Enum.all?(ticket, fn i -> Enum.any?(ranges, fn range -> i in range end) end) end)
    |> Enum.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(
         fn list ->
           Enum.map(list, fn x -> MapSet.new(all_possible_labels_for_field(x, rules)) end)
           |> Enum.reduce(fn y, acc -> MapSet.intersection(acc, y) end)
         end
       )
    |> crush_while_unfinished
    |> Enum.filter(fn {_, y} -> String.starts_with?(y, "departure") end)
    |> Enum.map(fn {x, _} -> x end)
    |> Enum.map(fn index -> Enum.at(my_ticket, index) end)
    |> Enum.reduce(1, &(&1 * &2))
  end
end
