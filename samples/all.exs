alias Aoc2020.{Day1, Day2, Day3, Day4, Day5, Day6, Day7, Day8, Day9, Day10, Day11}

Benchee.run(
  %{
    "day 1 part 1" => fn -> Day1.part1() end,
    "day 1 part 2" => fn -> Day1.part2() end,
    "day 2 part 1" => fn -> Day2.part1() end,
    "day 2 part 2" => fn -> Day2.part2() end,
    "day 3 part 1" => fn -> Day3.part1() end,
    "day 3 part 2" => fn -> Day3.part2() end,
    "day 4 part 1" => fn -> Day4.part1() end,
    "day 4 part 2" => fn -> Day4.part2() end,
    "day 5 part 1" => fn -> Day5.part1() end,
    "day 5 part 2" => fn -> Day5.part2() end,
    "day 6 part 1" => fn -> Day6.part1() end,
    "day 6 part 2" => fn -> Day6.part2() end,
    "day 7 part 1" => fn -> Day7.part1() end,
    "day 7 part 2" => fn -> Day7.part2() end,
    "day 8 part 1" => fn -> Day8.part1() end,
    "day 8 part 2" => fn -> Day8.part2() end,
    "day 9 part 1" => fn -> Day9.part1() end,
    "day 9 part 2" => fn -> Day9.part2() end,
    "day 10 part 1" => fn -> Day10.part1() end,
    "day 10 part 2" => fn -> Day10.part2() end,
    "day 11 part 1" => fn -> Day11.part1() end,
    "day 11 part 2" => fn -> Day11.part2() end,
  },
  formatters: [
    {
      Benchee.Formatters.Console,
      [comparison: false, extended_statistics: true]
    }
  ],
  parallel: 12,
  memory_time: 2,
)
