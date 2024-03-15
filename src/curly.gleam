import gleam/string
import gleam/string_builder
import gleam/list
import gleam/result

pub fn debug(
  with values: List(a),
  to format: String,
) -> Result(String, list.LengthMismatch) {
  values
  |> list.map(string.inspect)
  |> display(format)
}

pub fn display(
  with values: List(String),
  to format: String,
) -> Result(String, list.LengthMismatch) {
  use with_values <- result.try(
    format
    |> string.split("{}")
    |> list.strict_zip(
      values
      |> list.append([""]),
    ),
  )
  with_values
  |> list.fold(string_builder.new(), fn(builder, with_value) {
    let #(chunk, value) = with_value
    builder
    |> string_builder.append(chunk)
    |> string_builder.append(value)
  })
  |> string_builder.to_string
  |> Ok
}
