import gleam/bool
import gleam/int
import gleam/list
import gleam/option
import gleam/order
import gleam/string
import gleeunit/should
import simplifile

fn in_range(range: #(Int, Int), val: Int) -> Bool {
  let #(low, high) = range
  use <- bool.guard(when: val >= low && val <= high, return: True)
  False
}

fn merge_all_ranges_loop(
  ranges: List(#(Int, Int)),
  acc: List(#(Int, Int)),
) -> List(#(Int, Int)) {
  case ranges {
    [] -> acc
    [#(l1, h1), #(l2, h2), ..rest] if l2 <= h1 ->
      merge_all_ranges_loop([#(l1, int.max(h1, h2)), ..rest], acc)
    [a, ..rest] -> merge_all_ranges_loop(rest, [a, ..acc])
  }
}

fn merge_all_ranges(ranges: List(#(Int, Int))) {
  ranges
  |> list.sort(fn(r1, r2) {
    int.compare(r1.0, r2.0) |> order.break_tie(int.compare(r1.1, r2.1))
  })
  |> merge_all_ranges_loop([])
}

pub fn main() {
  let assert Ok(input) = simplifile.read("../input/day5.txt")
  let lines =
    input
    |> string.split("\n")
    |> list.map(fn(line) { line |> string.trim })

  let ranges =
    lines
    |> list.filter(fn(line) { line |> string.contains("-") })
    |> list.map(fn(line) {
      let assert Ok(#(low, high)) = line |> string.split_once("-")
      #(int.parse(low) |> should.be_ok, int.parse(high) |> should.be_ok)
    })

  let product_ids =
    lines
    |> list.filter(fn(line) {
      line
      |> string.contains("-")
      |> bool.or(string.is_empty(line))
      |> bool.negate
    })
    |> list.map(fn(line) { line |> int.parse |> should.be_ok })

  let part_1 =
    product_ids
    |> list.fold(0, fn(acc, value) {
      case list.any(ranges, fn(range) { in_range(range, value) }) {
        True -> acc + 1
        False -> acc
      }
    })

  echo "Day 5 - Part 1: " <> int.to_string(part_1)

  let part_2 =
    ranges
    |> merge_all_ranges
    |> list.fold(0, fn(acc, range) {
      let #(low, high) = range
      acc + high - low + 1
    })
  echo "Day 5 - Part 2: " <> int.to_string(part_2)
}
