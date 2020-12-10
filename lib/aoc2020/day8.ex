defmodule Aoc2020.Day8 do
  def instruction("acc " <> amount) do
    {num, ""} = Integer.parse(amount)
    {:acc, num}
  end
  def instruction("jmp " <> amount) do
    {num, ""} = Integer.parse(amount)
    {:jmp, num}
  end
  def instruction("nop " <> amount) do
    {num, ""} = Integer.parse(amount)
    {:nop, num}
  end

  def input() do
    File.read!("input/day8.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&instruction/1)
  end

  def execute({:acc, amount}, acc, pc, instructions) do
    {List.replace_at(instructions, pc, :infinite_loop), acc + amount, pc + 1}
  end

  def execute({:nop, _}, acc, pc, instructions) do
    {List.replace_at(instructions, pc, :infinite_loop), acc, pc + 1}
  end

  def execute({:jmp, amount}, acc, pc, instructions) do
    {List.replace_at(instructions, pc, :infinite_loop), acc, pc + amount}
  end

  def run(instructions, acc, pc) do
    case Enum.at(instructions, pc) do
      :infinite_loop -> {acc, pc}
      nil -> {acc, pc}
      x ->
        {instructions, acc, pc} = execute(x, acc, pc, instructions)
        run(instructions, acc, pc)
    end
  end

  def run2(index_to_hack, instructions, acc, pc) do
    case Enum.at(instructions, pc) do
      :infinite_loop -> {:loop, acc, pc}
      nil -> {:normal, acc, pc}
      x ->
        {instructions, acc, pc} = execute(x, acc, pc, instructions)
        run2(index_to_hack, instructions, acc, pc)
    end
  end

  def part1() do
    {acc, _} = input()
               |> run(0, 0)
    acc
  end

  def part2() do
    program = input()
    {:normal, acc, _pc} = Enum.map(
      0..(length(program) - 1),
      fn i ->
        instructions = List.replace_at(
          program,
          i,
          case Enum.at(program, i) do
            {:nop, x} -> {:jmp, x}
            {:jmp, x} -> {:nop, x}
            x -> x
          end
        )

        run2(i, instructions, 0, 0)
      end
    )
    |> Enum.find(fn {_thing, _acc, pc} -> pc == length(program) end)
    acc
  end
end

