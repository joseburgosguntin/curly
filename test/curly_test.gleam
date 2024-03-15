import gleeunit
import gleeunit/should
import curly
import gleam/dynamic
import gleam/int

pub fn main() {
  gleeunit.main()
}

pub fn success_test() {
  []
  |> curly.debug("hey")
  |> should.equal(
    "hey"
    |> Ok,
  )

  [1]
  |> curly.debug("hey {}")
  |> should.equal(
    "hey 1"
    |> Ok,
  )

  [
    "joe"
      |> dynamic.from,
    1
      |> dynamic.from,
  ]
  |> curly.debug("hey {}, {}")
  |> should.equal(
    "hey \"joe\", 1"
    |> Ok,
  )

  [
    10
    |> int.to_string,
  ]
  |> curly.display_pad("bro {:03} hey")
  |> should.equal(
    "bro 010 hey"
    |> Ok,
  )
  [
    10
    |> int.to_string,
  ]
  |> curly.display_pad("{:.3} hey")
  |> should.equal(
    ".10 hey"
    |> Ok,
  )

  [
    10
    |> int.to_string,
  ]
  |> curly.display_pad("{:3} hey")
  |> should.equal(
    " 10 hey"
    |> Ok,
  )
}

pub fn fail_test() {
  [1]
  |> curly.debug("hey")
  |> should.be_error()

  []
  |> curly.debug("hey {}")
  |> should.be_error()

  [1]
  |> curly.debug("hey {}, {}")
  |> should.be_error()

  [
    10
    |> int.to_string,
  ]
  |> curly.display_pad("{bla} hey")
  |> should.be_error()
}
