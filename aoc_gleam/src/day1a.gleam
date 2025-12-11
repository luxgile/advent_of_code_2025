import gleam/io
import gleam/uri
import gleam/http/request
import gleam/httpc
import gleam/result

fn get_input(day: Int) {
  let assert Ok(request) = request.to("https://adventofcode.com/2025/day/1/input")
  use response <- result.try(httpc.send(request))
  Ok(response.body)
}

pub fn main() {
  let assert Ok(body) = get_input(1)
  io.print(body)
}
