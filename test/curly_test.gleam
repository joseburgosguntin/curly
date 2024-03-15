import gleeunit
import gleeunit/should
import curly
import gleam/dynamic

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
}
