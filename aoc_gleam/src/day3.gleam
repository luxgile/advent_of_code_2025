import gleam/bool
import gleam/dict
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import gleeunit/should
import simplifile

fn get_pair_from_index(line: String, index: Int, length: Int) -> Int {
  let first = string.slice(line, index, 1)
  let assert Ok(max) =
    string.slice(line, index + 1, length + index)
    |> string.to_graphemes
    |> list.map(fn(x) {
      let assert Ok(n) = int.parse(first <> x)
      n
    })
    |> list.max(int.compare)
  max
}

fn get_biggest_pair(line) -> Int {
  let length = string.length(line) - 1
  use <- bool.guard(when: length == -1, return: 0)
  let assert Ok(max) =
    list.range(0, length - 1)
    |> list.map(fn(x) { get_pair_from_index(line, x, length) })
    |> list.max(int.compare)
  max
}

fn optimise_bank(bank: List(Int), n_left: Int) -> Int {
  case bank, n_left {
    [], _ -> 0
    bank, n_left -> {
      let #(max, rest, index) =
        list.fold(bank, #(0, [], -1), fn(acc, item) {
          let #(current_max, rest, index) = acc
          let head = list.first(rest) |> should.be_ok
          let rest = list.drop(rest, 1)
          use <- bool.guard(when: head > current_max, return: #(head, rest, index))
          #(current_max, rest, index + 1)
        })

      let #(max, rest) = #(max, list.reverse(rest))

      max
      * float.round(should.be_ok(int.power(10, int.to_float(n_left - 1))))
      + optimise_bank(rest, n_left - 1)
    }
  }
}

pub fn main() {
  let assert Ok(input) = simplifile.read("../input/day3.txt")
  let lines = string.split(input, "\n") |> list.map(fn(x) { string.trim(x) })

  let part_1 = lines |> list.fold(0, fn(x, line) { get_biggest_pair(line) + x })
  echo "Day 3 - Part 1: " <> int.to_string(part_1)

  let part_2 =
    lines
    |> list.fold(0, fn(x, line) {
      let numbers =
        string.to_graphemes(line)
        |> list.map(fn(x) { x |> int.parse |> should.be_ok })
      x + optimise_bank(numbers, 12)
    })
  echo "Day 3 - Part 2: " <> int.to_string(part_2)
}
