alias Aoc2020.{Day1, Day2, Day3, Day4}

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
  },
  formatters: [
    {
      Benchee.Formatters.Console,
      [comparison: false, extended_statistics: true]
    }
  ],
  parallel: 12,
)
