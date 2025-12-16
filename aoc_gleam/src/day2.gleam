import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import gleam_community/maths
import gleam/bit_array
import simplifile

fn is_invalid_id_part_2(id: Int) -> Bool {
  let id_str = int.to_string(id)
  let len = string.length(id_str)
  let bin = bit_array.from_string(id_str)
  let divisors = maths.divisors(len)
  let divisors = divisors |> list.take(list.length(divisors))
  divisors
  |> list.any(fn(x) {
    let repetitions =
      id_str
      |> string.split(string.slice(id_str, 0, x))
      |> list.length
      |> int.subtract(1)
      |> int.max(0)
    let expected_repetitions = len / x
    repetitions > 1 && repetitions == expected_repetitions
  })
}

fn is_invalid_id_part_1(id: Int) -> Bool {
  let id_str = int.to_string(id)
  let len = string.length(id_str)
  case len % 2 {
    0 -> {
      let midpoint = len / 2
      string.slice(id_str, 0, midpoint) == string.slice(id_str, midpoint, len)
    }
    _ -> False
  }
}

fn loop_ranges(ranges, id_check, result) -> Int {
  case ranges {
    [] -> result
    [#(low, high), ..rest] -> {
      let invalid_count =
        list.range(low, high)
        |> list.map(fn(x) {
          case id_check(x) {
            True -> x
            False -> 0
          }
        })
        |> list.fold(0, int.add)
      loop_ranges(rest, id_check, result + invalid_count)
    }
  }
}

pub fn main() {
  let assert Ok(input) = simplifile.read("../input/day2.txt")

  // Parsing input
  let ranges =
    input
    |> string.trim
    |> string.split(",")
    |> list.map(fn(x) {
      let assert [Ok(low), Ok(high)] =
        string.split(x, "-") |> list.map(int.parse)
      #(low, high)
    })

  echo "Day 2 - Part 1: "
    <> int.to_string(loop_ranges(ranges, is_invalid_id_part_1, 0))
  echo "Day 2 - Part 2: "
    <> int.to_string(loop_ranges(ranges, is_invalid_id_part_2, 0))
}
