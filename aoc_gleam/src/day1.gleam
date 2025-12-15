import gleam/int
import gleam/list
import gleam/string
import simplifile

pub fn parse_rotation(str: String) {
  let assert Ok(rotation) = case str {
    "" -> Ok(0)
    "L" <> n -> { "-" <> n } |> int.parse
    "R" <> n -> n |> int.parse
    _ -> panic as "invalid rotation"
  }
  rotation
}

pub fn part_1(dial, rotations, result) {
  case rotations {
    [rotation, ..rest] -> {
      let dial = { dial + rotation } % 100
      case dial {
        0 -> part_1(dial, rest, result + 1)
        _ -> part_1(dial, rest, result)
      }
    }
    [] -> result
  }
}

pub fn part_2(dial, rotations, result) {
  case rotations {
    [] -> result
    [rotation, ..rest] -> {
      let new_dial = dial + rotation
      let carry = int.absolute_value(new_dial) / 100
      let result = case new_dial {
        _ if new_dial > 99 -> result + carry
        _ if new_dial <= 0 -> {
          let result = result + carry
          case dial {
            0 -> result
            _ -> result + 1
          }
        }
        _ -> result
      }

      let assert Ok(new_dial) = int.modulo(new_dial, 100)
      part_2(new_dial, rest, result)
    }
  }
}

pub fn main() {
  let assert Ok(input) = simplifile.read("../input/day1.txt")
  let rotations =
    input
    |> string.split("\n")
    |> list.map(string.trim)
    |> list.map(parse_rotation)

  echo "day 1 - part 1: " <> part_1(50, rotations, 0) |> int.to_string
  echo "day 1 - part 2: " <> part_2(50, rotations, 0) |> int.to_string
}
