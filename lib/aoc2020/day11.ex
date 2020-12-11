defmodule Aoc2020.Day11 do
  def type("#"), do: :taken
  def type("."), do: :floor
  def type("L"), do: :empty
  def token(:taken), do: "#"
  def token(:floor), do: "."
  def token(:empty), do: "L"

  def print_grid(grid) do
    {{min_x, min_y}, _} = Enum.min(grid)
    {{max_x, max_y}, _} = Enum.max(grid)

    cords = for y <- min_y..max_y, x <- min_x..max_x, do: [x, y]
    Enum.each(
      cords,
      fn [x, y] ->
        token = Map.get(grid, {x, y})
        IO.write("#{token(token)}")
        if x == max_x do
          IO.write("\n")
        end
      end
    )
    IO.write("\n")
    grid
  end

  def input() do
    File.read!("input/day11.txt")
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(
         %{},
         fn {row, y}, acc ->
           row
           |> String.graphemes()
           |> Enum.with_index()
           |> Enum.reduce(
                acc,
                fn {col, x}, acc ->
                  Map.put(acc, {x, y}, type(col))
                end
              )
         end
       )
  end

  def neighbours(grid, x, y) do
    [
      Map.get(grid, {x + 1, y + 1}, :space),
      Map.get(grid, {x - 1, y - 1}, :space),
      Map.get(grid, {x - 1, y + 1}, :space),
      Map.get(grid, {x + 1, y - 1}, :space),
      Map.get(grid, {x + 1, y}, :space),
      Map.get(grid, {x - 1, y}, :space),
      Map.get(grid, {x, y + 1}, :space),
      Map.get(grid, {x, y - 1}, :space)
    ]
  end

  def step(grid) do
    Enum.reduce(
      Map.keys(grid),
      %{},
      fn {x, y}, acc ->
        token = Map.get(grid, {x, y})
        is_empty = token == :empty
        is_taken = token == :taken
        neighbours = neighbours(grid, x, y)
        taken_seats = neighbours
                      |> Enum.count(&(&1 == :taken))
        cond do
          token == :floor -> Map.put(acc, {x, y}, :floor)
          is_empty && taken_seats == 0 -> Map.put(acc, {x, y}, :taken)
          is_taken && taken_seats >= 4 -> Map.put(acc, {x, y}, :empty)
          true -> Map.put(acc, {x, y}, token)
        end
      end
    )
  end

  def simulate(grid, steps \\ 0) do
    new = step(grid)
    if new != grid do
      simulate(new, steps + 1)
    else
      new
    end
  end

  def look(grid, {x, y}, lookfn) do
    case Map.get(grid, {x, y}, :space) do
      :space -> :empty
      :taken -> :taken
      :empty -> :empty
      _ -> look(grid, lookfn.(x, y), lookfn)
    end
  end

  def neighbours_in_sight(grid, x, y) do
    [
      look(grid, {x + 1, y + 1}, &({&1 + 1, &2 + 1})),
      look(grid, {x - 1, y - 1}, &({&1 - 1, &2 - 1})),
      look(grid, {x - 1, y + 1}, &({&1 - 1, &2 + 1})),
      look(grid, {x + 1, y - 1}, &({&1 + 1, &2 - 1})),
      look(grid, {x + 1, y}, &({&1 + 1, &2})),
      look(grid, {x - 1, y}, &({&1 - 1, &2})),
      look(grid, {x, y + 1}, &({&1, &2 + 1})),
      look(grid, {x, y - 1}, &({&1, &2 - 1})),
    ]
  end

  def step_sight(grid) do
    Enum.reduce(
      Map.keys(grid),
      %{},
      fn {x, y}, acc ->
        token = Map.get(grid, {x, y})
        is_empty = token == :empty
        is_taken = token == :taken
        taken_seats = neighbours_in_sight(grid, x, y)
                      |> Enum.count(&(&1 == :taken))
        cond do
          token == :floor -> Map.put(acc, {x, y}, :floor)
          is_empty && (taken_seats == 0) -> Map.put(acc, {x, y}, :taken)
          is_taken && (taken_seats >= 5) -> Map.put(acc, {x, y}, :empty)
          true -> Map.put(acc, {x, y}, token)
        end
      end
    )
  end

  def simulate_sight(grid, steps \\ 0) do
    new = step_sight(grid)
    if new != grid do
      simulate_sight(new, steps + 1)
    else
      new
    end
  end

  def part1() do
    input()
    |> simulate
    |> Map.values()
    |> Enum.count(&(&1 == :taken))
  end

  def part2() do
    input()
    |> simulate_sight
    |> Map.values()
    |> Enum.count(&(&1 == :taken))
  end
end
