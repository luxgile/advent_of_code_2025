import gleam/int
import gleam/list
import gleam/string
import simplifile

fn is_invalid_id(id) {
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

fn part_1(ranges, result) -> Int {
  case ranges {
    [] -> result
    [range, ..rest] -> {
      let assert #(low, high) = range
      let invalid_count =
        list.range(low, high)
        |> list.map(fn(x) {
          case is_invalid_id(x) {
            True -> x
            False -> 0
          }
        })
        |> list.fold(0, int.add)
      part_1(rest, result + invalid_count)
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

  echo "Day 2 - Part 1: " <> int.to_string(part_1(ranges, 0))
}
