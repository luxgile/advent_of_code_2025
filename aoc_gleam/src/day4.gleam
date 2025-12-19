import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string

// import gleeunit/should
import simplifile

pub fn get_cell(grid, x, y) {
  dict.get(grid, #(x, y)) |> result.unwrap(False)
}

pub fn count_surrounding(grid, x: Int, y: Int) -> Int {
  [
    #(x + 1, y + 1),
    #(x + 1, y),
    #(x + 1, y - 1),
    #(x, y - 1),
    #(x - 1, y - 1),
    #(x - 1, y),
    #(x - 1, y + 1),
    #(x, y + 1),
  ]
  |> list.fold(0, fn(acc, pos) {
    let #(a, b) = pos
    use <- bool.guard(when: get_cell(grid, a, b), return: acc + 1)
    acc
  })
}

pub fn grid_length(grid) {
  dict.fold(grid, 0, fn(acc, _key, val) {
    case val {
      True -> acc + 1
      False -> acc
    }
  })
}

pub fn reduce_grid(grid: dict.Dict(#(Int, Int), Bool), acc: Int) -> Int {
  let length = grid_length(grid)
  let grid =
    dict.map_values(grid, fn(pos, val) {
      use <- bool.guard(when: !val, return: False)
      let #(x, y) = pos
      use <- bool.guard(when: count_surrounding(grid, x, y) >= 4, return: val)
      False
    })
  let diff = length - grid_length(grid)
  case diff {
    0 -> acc
    _ -> reduce_grid(grid, acc + diff)
  }
}

pub fn main() {
  let assert Ok(input) = simplifile.read("../input/day4.txt")
  let lines =
    input
    |> string.split("\n")
    |> list.map(fn(line) {
      line
      |> string.trim
      |> string.to_graphemes
    })

  // Grid as a dict with key the coordinates as #(x, y)
  let grid =
    list.index_fold(lines, dict.new(), fn(d, line, y) {
      list.index_fold(line, d, fn(d, c, x) {
        let val = case c {
          "@" -> True
          "." -> False
          _ -> panic
        }
        dict.insert(d, #(x, y), val)
      })
    })

  let part_1 =
    dict.fold(grid, 0, fn(acc, key, val) {
      use <- bool.guard(when: !val, return: acc)
      let #(x, y) = key
      let count = count_surrounding(grid, x, y)
      use <- bool.guard(when: count < 4, return: acc + 1)
      acc
    })
  echo "Day 4 - Part 1: " <> int.to_string(part_1)

  let part_2 = reduce_grid(grid, 0)
  echo "Day 4 - Part 2: " <> int.to_string(part_2)
}
