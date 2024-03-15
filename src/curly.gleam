import gleam/string
import gleam/string_builder
import gleam/list
import gleam/result
import gleam/int

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
  use with_values <- result.map(
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
}

pub fn debug_pad(
  with values: List(a),
  to format: String,
) -> Result(String, DisplayPadError) {
  values
  |> list.map(string.inspect)
  |> display_pad(format)
}

pub type DisplayPadError {
  LengthMismatch
  NoClossingBrace
  NonNumberPadding
  InvalidFormating
}

/// allows for optional padding
pub fn display_pad(
  with values: List(String),
  to format: String,
) -> Result(String, DisplayPadError) {
  let end_with_format =
    format
    |> string.split("{")
  let first =
    end_with_format
    |> list.first
    |> result.unwrap("")
  let interested =
    end_with_format
    |> list.drop(1)
    |> list.map(string.split_once(_, "}"))
    |> result.all
    |> result.replace_error(LengthMismatch)
  use interested <- result.try(interested)
  interested
  |> list.zip(values)
  |> list.try_fold(string_builder.from_string(first), fn(builder, x) {
    let #(#(config, after), value) = x

    let padding = case config {
      "" -> Ok("")
      ":" <> amount -> {
        use first <- result.try(
          amount
          |> string.first
          |> result.replace_error(InvalidFormating),
        )
        let #(char, amount) = case first {
          "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> #(" ", amount)
          char -> #(char, string.drop_left(amount, 1))
        }
        use amount <- result.map(
          amount
          |> int.parse
          |> result.replace_error(NonNumberPadding),
        )
        amount - string.length(value)
        |> string.repeat(char, _)
      }
      _ -> Error(InvalidFormating)
    }
    use padding <- result.map(padding)

    builder
    |> string_builder.append(padding)
    |> string_builder.append(value)
    |> string_builder.append(after)
  })
  |> result.map(string_builder.to_string)
}
