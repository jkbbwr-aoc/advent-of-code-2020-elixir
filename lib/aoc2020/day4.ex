defmodule Aoc2020.Day4 do

  def convert([field, value])
      when field in ~w(byr iyr eyr cid) do
    case Integer.parse(value) do
      {num, ""} -> {String.to_atom(field), num}
      _ -> {String.to_atom(field), :error}
    end
  end

  def convert(["hgt", value]) do
    {:hgt, Integer.parse(value)}
  end

  def convert(["pid", value]) do
    # this sucks but I am too tired to figure out how to do it better.
    nums = try do
      value
      |> String.graphemes()
      |> Enum.map(
           fn value ->
             case Integer.parse(value) do
               {num, ""} -> num
               :error -> throw(:error)
             end
           end
         )
    catch
      _ -> []
    end

    {:pid, nums}
  end

  def convert([x, y]), do: {String.to_atom(x), y}

  def process_entry(fields) do
    fields
    |> Enum.map(&(String.split(&1, ":")))
    |> Enum.map(&convert/1)
    |> Keyword.new
  end

  def valid_passport_fields([:byr, :cid, :ecl, :eyr, :hcl, :hgt, :iyr, :pid]), do: true
  def valid_passport_fields([:byr, :ecl, :eyr, :hcl, :hgt, :iyr, :pid]), do: true
  def valid_passport_fields(_), do: false

  def input() do
    File.read!("input/day4.txt")
    |> String.split(" ")
    |> Enum.flat_map(&(String.split(&1, "\n")))
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.filter(&(&1 != [""]))
    |> Enum.map(&process_entry/1)
  end

  def validate_byr(year) when year in 1920..2002, do: :ok
  def validate_byr(_), do: {:error, :bad_byr}

  def validate_iyr(year) when year in 2010..2020, do: :ok
  def validate_iyr(_), do: {:error, :bad_iyr}

  def validate_eyr(year) when year in 2020..2030, do: :ok
  def validate_eyr(_), do: {:error, :bad_eyr}

  def validate_hgt({height, "cm"}) when height in 150..193, do: :ok
  def validate_hgt({height, "in"}) when height in 59..76, do: :ok
  def validate_hgt(_), do: {:error, :bad_hgt}

  def validate_hcl(<<"#", rest :: binary - size(6)>>) do
    Regex.match?(~r/^[[:xdigit:]]$/, rest)
    :ok
  end
  def validate_hcl(_), do: {:error, :bad_hcl}

  def validate_ecl(ecl) when ecl in ~w(amb blu brn gry grn hzl oth), do: :ok
  def validate_ecl(_), do: {:error, :bad_ecl}

  def validate_pid(pid) when length(pid) == 9, do: :ok
  def validate_pid(_), do: {:error, :bad_pid}

  def validate_rules(entry) do
    with :ok <- validate_byr(entry[:byr]),
         :ok <- validate_iyr(entry[:iyr]),
         :ok <- validate_eyr(entry[:eyr]),
         :ok <- validate_hgt(entry[:hgt]),
         :ok <- validate_hcl(entry[:hcl]),
         :ok <- validate_ecl(entry[:ecl]),
         :ok <- validate_pid(entry[:pid]) do
      true
    else
      {:error, _error} -> false
    end
  end

  def part1() do
    input()
    |> Enum.filter(
         fn entry ->
           entry
           |> Keyword.keys()
           |> Enum.sort()
           |> valid_passport_fields()
         end
       )
    |> Enum.count()
  end

  def part2() do
    input()
    |> Enum.filter(
         fn entry ->
           entry
           |> Keyword.keys()
           |> Enum.sort()
           |> valid_passport_fields()
         end
       )
    |> Enum.filter(&validate_rules/1)
    |> Enum.count()
  end
end
