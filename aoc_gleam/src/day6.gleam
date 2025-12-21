import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import gleeunit/should
import simplifile

type Op {
  Add
  Mult
}

pub fn main() {
  let assert [line1, line2, line3, line4, ops] =
    simplifile.read("../input/day6.txt")
    |> should.be_ok
    |> string.split("\n")
    |> list.filter(fn(line) { line |> string.is_empty |> bool.negate })

  let lines =
    [line1, line2, line3, line4]
    |> list.map(fn(line) {
      line
      |> string.split(" ")
      |> list.filter(fn(val) { val |> string.is_empty |> bool.negate })
      |> list.map(fn(val) { val |> int.parse |> should.be_ok })
    })
    |> list.interleave
    |> list.sized_chunk(4)

  let ops =
    ops
    |> string.split(" ")
    |> list.filter(fn(val) { val |> string.is_empty |> bool.negate })
    |> list.map(fn(op) {
      case op {
        "+" -> Add
        "*" -> Mult
        _ -> panic
      }
    })

  let part_1 =
    lines
    |> list.map2(ops, fn(line, op) {
      case op {
        Add -> list.fold(line, 0, int.add)
        Mult -> list.fold(line, 1, int.multiply)
      }
    })
    |> list.fold(0, int.add)

  echo "Day 6 - Part 1: " <> int.to_string(part_1)

  let part_2 =
    lines
    |> list.map2(ops, fn(line, op) {
      let values =
        list.map(line, fn(val) {
          val |> int.to_string |> string.to_graphemes |> list.reverse
        })
        |> list.transpose
        |> list.map(fn(graphemes) {
          graphemes |> list.fold("", string.append) |> int.parse |> should.be_ok
        }) |> echo

      case op {
        Add -> list.fold(values, 0, int.add)
        Mult -> list.fold(values, 1, int.multiply)
      }
    })
    |> list.fold(0, int.add)

  echo "Day 6 - Part 2: " <> int.to_string(part_2)
}
