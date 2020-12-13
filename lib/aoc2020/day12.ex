defmodule Aoc2020.Day12 do
  def parse("N" <> number), do: {:north, String.to_integer(number)}
  def parse("S" <> number), do: {:south, String.to_integer(number)}
  def parse("E" <> number), do: {:east, String.to_integer(number)}
  def parse("W" <> number), do: {:west, String.to_integer(number)}
  def parse("L" <> number), do: {:left, String.to_integer(number)}
  def parse("R" <> number), do: {:right, String.to_integer(number)}
  def parse("F" <> number), do: {:forward, String.to_integer(number)}

  @directions_left [:north, :west, :south, :east]
  @directions_right [:south, :west, :north, :east]

  def input() do
    File.read!("input/day12.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
  end

  def input(text) do
    text
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
  end

  def direction(stream, facing, amount) do
    [new_facing] = Stream.cycle(stream)
                   |> Stream.drop_while(&(&1 != facing))
                   |> Stream.drop(round(amount / 90))
                   |> Enum.take(1)
    new_facing
  end

  def step({x, y, facing}, {:forward, amount}), do: step({x, y, facing}, {facing, amount})
  def step({x, y, facing}, {:north, amount}), do: {x, y + amount, facing}
  def step({x, y, facing}, {:south, amount}), do: {x, y - amount, facing}
  def step({x, y, facing}, {:east, amount}), do: {x + amount, y, facing}
  def step({x, y, facing}, {:west, amount}), do: {x - amount, y, facing}
  def step({x, y, facing}, {:left, amount}), do: {x, y, direction(@directions_left, facing, amount)}
  def step({x, y, facing}, {:right, amount}), do: {x, y, direction(@directions_right, facing, amount)}

  def step_waypoint({{x, y}, ship}, {:north, amount}),
      do: {{x, y + amount}, ship}
  def step_waypoint({{x, y}, ship}, {:south, amount}),
      do: {{x, y - amount}, ship}
  def step_waypoint({{x, y}, ship}, {:east, amount}),
      do: {{x + amount, y}, ship}
  def step_waypoint({{x, y}, ship}, {:west, amount}),
      do: {{x - amount, y}, ship}

  def step_waypoint({{x, y}, ship}, {:left, 90}), do: {{-y, x}, ship}
  def step_waypoint({{x, y}, ship}, {:left, 180}), do: {{-x, -y}, ship}
  def step_waypoint({{x, y}, ship}, {:left, 270}), do: {{y, -x}, ship}
  def step_waypoint({{x, y}, ship}, {:left, 360}), do: {{x, y}, ship}

  def step_waypoint({{x, y}, ship}, {:right, 90}), do: {{y, -x}, ship}
  def step_waypoint({{x, y}, ship}, {:right, 180}), do: {{-x, -y}, ship}
  def step_waypoint({{x, y}, ship}, {:right, 270}), do: {{-y, x}, ship}
  def step_waypoint({{x, y}, ship}, {:right, 360}), do: {{x, y}, ship}

  def step_waypoint({{x, y}, {ship_x, ship_y, ship_facing}}, {:forward, amount}) do
    new_x = ship_x + (amount * x)
    new_y = ship_y + (amount * y)
    {{x, y}, {new_x, new_y, ship_facing}}
  end

  def simulate([], {x, y, facing}), do: {x, y, facing}
  def simulate([next | rest], current), do: simulate(rest, step(current, next))

  def simulate_waypoint([], result), do: result
  def simulate_waypoint([next | rest], current), do: simulate_waypoint(rest, step_waypoint(current, next))

  def part1() do
    {x, y, _} = input()
                |> simulate({0, 0, :east})
    abs(x) + abs(y)
  end

  def part2() do
    {_, {x, y, _}} = input()
                     |> simulate_waypoint({{10, 1}, {0, 0, :east}})
    abs(x) + abs(y)
  end
end
